module QuickSearch
  class BestBetsSearcher < QuickSearch::Searcher

    # Bestbets should search in the following order:
    # 1. Bestbet solr index
    # 2. course views
    # 3. Journal best bet
    # 4. database best bet
    # 5. project reports best bet

    def search
      search_best_bets_index || search_course_tools_best_bets || search_journal_best_bets || search_database_best_bets || search_project_best_bets
    end

    def results
      if results_list
        results_list
      else
        @results_list = []
        unless @response.blank?
          @results_list << @response
        end
        @results_list
      end
    end

    def total
      results.size
    end

    private

    def search_project_best_bets
      base_url = APP_CONFIG['best_bets']['project_reports_api']

      params = {
        'title' => http_request_queries['not_escaped']
      }

      url = base_url + params.to_query
      response = @http.get(url)

      if response.body.blank?
        @response = nil
      else
        parsed_response = JSON.parse(response.body)
        @response = process_json_project_response(parsed_response)
      end
    end

    def process_json_project_response(json_response)
      return nil unless json_response

      # only return a response if there's an exact match on query
      json_response.each do |project|
        if project['name'].downcase == http_request_queries['not_escaped'].downcase
          return create_project_result(project)
        end
      end
      return nil
    end

    def create_project_result(project)
      result = OpenStruct.new

      result.link = project['project_link'] || project['report_link']
      result.best_bets_type = 'best-bets-project-report'
      result.id = project['name']
      result.title = project['name']
      # the description comes to us with markup - remove that
      # but we need to sanitize the URL-encoding
      result.description = sanitize(strip_tags(project['body']))

      result
    end

    # Database and Journals algorithmic Best Bets

    def search_journal_best_bets
      @response = ematrix_query
    end

    def search_database_best_bets
      @response = ematrix_query('database')
    end

    def ematrix_query(type='journal')
      base_url = APP_CONFIG['best_bets']['ematrix']['base_request_url']

      params = {
        'action' => 'search',
        'terms' => '"' + query_quotes_stripped + '"',
        'first' => "0",
        'max' => 1,
        'key' => APP_CONFIG['best_bets']['ematrix']['client_key']
      }

      if type == 'database'
        params['type'] = 'databases'
      end

      url = base_url + params.to_query
      response = @http.get(url)

      if type == 'database'
        return parse_ematrix_results(Nokogiri::XML(response.body), 'database')
      else
        return parse_ematrix_results(Nokogiri::XML(response.body))
      end
    end

    def parse_ematrix_results(response, type='journal')
        result_count = response.at_xpath('//totalResults').content

        if result_count == '0'
          return nil
        end

        result = OpenStruct.new
        resp = response.xpath('//resource').first
        result.title = resp.at('title').content

        if result_count == '1' and (http_request_queries['not_escaped'].split.length > 1 or result.title.downcase == http_request_queries['not_escaped'])
          if type == 'database'
            result.link = ematrix_database_link(resp)
            result.best_bets_type = 'best-bets-algorithmic-database'
            result.id = result.title
          else
            result.link = APP_CONFIG['best_bets']['ematrix']['journal_base_url'] + resp.at('id')
            result.best_bets_type = 'best-bets-algorithmic-journal'
            result.id = result.title
          end
          return result
        else
          return nil
        end
    end

    def ematrix_database_link(value)
      value.xpath('//manifestation').each do |item|
        if item.at('format').content == "Electronic"
          return item.at_xpath('//location').content
        end
      end
    end

    # Course Tools Best Bets

    def search_course_tools_best_bets
      if course_tools_matches.blank?
        return nil
      else
        curriculum_code = course_tools_matches[:curriculum_code].upcase
        course_number = course_tools_matches[:course_number]
        result = OpenStruct.new
        result.title = "Library Tools for #{curriculum_code} #{course_number}"
        result.link = APP_CONFIG['best_bets']['course_tools_link_base'] + "#{curriculum_code}/#{course_number}"
        result.description = 'Get E-Reserves, Citation Builder, Article Search, and more for your course.'
        result.id = "course-tools-#{curriculum_code}-#{course_number}"
        result.best_bets_type = 'best-bets-course-tools'
      end
      @response = result
    end

    def course_tools_matches
      regex_matches = ''
      if regex_matches = course_tools_regex.match(query_quotes_stripped)
        regex_matches
      end
      regex_matches
    end

    def course_tools_regex
      /^(?<curriculum_code>[A-Za-z]{1,3})\s?(?<course_number>\d{3})\w?$/i
    end

    # Regular Best Bets

    def search_best_bets_index
      response = @http.get(query_url)
      parsed_response = JSON.parse(response.body)
      if parsed_response['response']['numFound'].to_s == '0'
        return nil
      else
        resp = parsed_response['response']['docs'][0]
        result = OpenStruct.new
        result.title = title(resp)
        result.link = link(resp)
        result.id = id(resp)
        result.description = description(resp)
        result.best_bets_type = 'best-bets-regular'

        @response = result
      end
    end

    def base_url
      APP_CONFIG['best_bets']['solr_url']
    end

    def query_url
      if http_request_queries['not_escaped'].split.size < 3
       # use non-analyzed keyword field with phrased search
        params = {
          'q' => %Q(keywords: "#{query_quotes_stripped}")
        }
      else
        # use DisMax query parser for longer queries
        params = {
          'defType' => 'dismax',
          'q' => query_quotes_stripped
        }
        if http_request_queries['not_escaped'].split.size < 6
          params['mm'] = '4'
        else
          params['mm'] = '6'
        end
      end

      # return results in json
      params['wt'] = 'json'
      base_url + params.to_query
    end

    def title(value)
      value['title']
    end

    def link(value)
      # TODO: should we make all URLS in the best_bets index absolute? currently some begin with a /
      if value['url'].start_with?('/')
        APP_CONFIG['website']['website_base_url'] + value['url']
      else
        value['url']
      end
    end

    def id(value)
      value['id']
    end

    def description(value)
      value['description']
    end

    # General Methods

    def query_quotes_stripped
      http_request_queries['not_escaped'].gsub('"', '')
    end

  end
end
