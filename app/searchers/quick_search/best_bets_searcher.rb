module QuickSearch
  class BestBetsSearcher < QuickSearch::Searcher

    def search
      search_best_bets_index
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
      QuickSearch::Engine::APP_CONFIG['best_bets']['solr_url']
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
        QuickSearch::Engine::APP_CONFIG['website']['website_base_url'] + value['url']
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
