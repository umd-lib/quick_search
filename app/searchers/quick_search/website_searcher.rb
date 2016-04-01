module QuickSearch
  class WebsiteSearcher < QuickSearch::Searcher

    def search
      response = @http.get(complete_url)
      @response = JSON.parse(response.body)
    end

    def results
      if results_list
        results_list
      else
        @results_list = []
        @response['response']['docs'].each do |value, each|
          result = OpenStruct.new
          result.title = title(value)
          result.link = link(value)
          result.description = description(result.link, value)
          @results_list << result
        end
        @results_list
      end
    end

    def total
      @response['response']['numFound'].to_s
    end

    def loaded_link
      link = "website/?q="
      link << http_request_queries['uri_escaped']
      unless scope.blank?
        link << "%20scope:(#{scope})"
      end
      link
    end

    def paging
      Kaminari.paginate_array(results, total_count: total.to_i).page(@page).per(@per_page)
    end

    private

    def base_url
      QuickSearch::Engine::APP_CONFIG['website']['solr_base_url']
    end

    def bq
      [
        '(url:www)^100000000000',
        '(*:* -url:findingaids)^100000000',
        '(*:* -url:news)^10000000000',
        '(*:* -url:event)^100000000000',
        '(*:* -url:events/registration/workshop)^100000000000',
        '(*:* -url:documents)^100000000000',
        '(*:* -url:node)^100000000000'
      ]
    end

    def parameters
      if http_request_queries['not_escaped'].blank?
        parameters = {
          'fl' => 'title,content,url',
          'q' => '*:*'
        }
      else
        parameters = {
          'defType' => 'dismax',
          'qf' => 'title^700 content^800 url^800',
          'pf' => 'title^1000000000 content^100 url^100',
          'ps' => '1',
          'mm' => '2',
          'fl' => 'title,url',
          'hl' => 'on',
          'hl.fl' => 'content',
          'hl.fragsize' => '170',
          'q' => http_request_queries['not_escaped'],
          'bq' => bq.join(' ')
        }
      end
      unless scope.blank?
        parameters['fq'] = "url:(#{@scope})"
      end
      parameters['wt'] = 'json'
      parameters['start'] = @offset
      parameters['rows'] = @per_page

      parameters
    end

    def complete_url
      base_url + parameters.to_query
    end

    def title(value)
      unless value['title'].blank?
        value['title']
      else
        value['url']
      end
    end

    def link(value)
      value['url']
    end

    def description(link, value)
      unless @response['highlighting'].blank?
        @response['highlighting'][link]['content'] ? response['highlighting'][link]['content'].first : ""
      else
        "..." << value['content'][1350, 170] << "..."
      end
    end

  end
end
