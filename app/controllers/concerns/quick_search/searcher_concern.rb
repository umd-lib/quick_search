module QuickSearch::SearcherConcern
  extend ActiveSupport::Concern

  include QuickSearch::OnCampus
  include QuickSearch::QueryParser
  include QuickSearch::EncodeUtf8
  require 'benchmark_logger'

  private

  def search_all_in_threads(primary_searcher = 'defaults')
    benchmark "%s server ALL" % CGI.escape(query.to_str) do
      search_threads = []
      @found_types = [] # add the types that are found to a navigation bar

      if primary_searcher == 'defaults'
        searchers = QuickSearch::Engine::APP_CONFIG['searchers']
      else
        searchers = QuickSearch::Engine::APP_CONFIG[primary_searcher]['with_paging']['searchers']
      end

      searchers.shuffle.each do |search_method|
        search_threads << Thread.new(search_method) do |sm|
          benchmark "%s server #{sm}" % CGI.escape(query.to_str) do
            begin
              klass = "QuickSearch::#{sm.camelize}Searcher".constantize
              http_client = HTTPClient.new
              update_searcher_timeout(http_client, search_method)
              # FIXME: Probably want to set paging and offset somewhere else.
              # searcher = klass.new(http_client, params_q_scrubbed, QuickSearch::Engine::APP_CONFIG['per_page'], 0, 1, on_campus?(request.remote_ip))
              if sm == primary_searcher
                per_page = QuickSearch::Engine::APP_CONFIG[primary_searcher]['with_paging']['per_page']
                searcher = klass.new(http_client, query, per_page, offset(page, per_page), page, on_campus?(ip), scope)
              else
                searcher = klass.new(http_client, query, QuickSearch::Engine::APP_CONFIG['per_page'], 0, 1, on_campus?(ip), scope)
              end
              searcher.search
              unless searcher.is_a? StandardError or searcher.results.blank?
                @found_types.push(sm)
              end
              instance_variable_set "@#{sm}", searcher
            rescue StandardError => e
              # logger.info e
              logger.info "FAILED SEARCH: #{sm} | #{params_q_scrubbed}"
              instance_variable_set :"@#{sm.to_s}", e
            end
          end
        end
      end
      search_threads.each {|t| t.join}
    end
  end


  def page
    if page_in_params?
      page = params[:page].to_i
    else
      page = 1
    end
    page
  end

  def offset(page, per_page)
    (page * per_page) - per_page
  end

  def query
    extracted_query(params_q_scrubbed)
  end

  def scope
    extracted_scope(params_q_scrubbed)
  end

  def update_searcher_timeout(client, search_method, xhr=false)
    timeout_type = xhr ? 'xhr_http_timeout' : 'http_timeout'
    timeout = QuickSearch::Engine::APP_CONFIG[timeout_type]

    if QuickSearch::Engine::APP_CONFIG.has_key? search_method and QuickSearch::Engine::APP_CONFIG[search_method].has_key? timeout_type
        timeout = QuickSearch::Engine::APP_CONFIG[search_method][timeout_type]
    end

    client.receive_timeout = timeout
    client.send_timeout = timeout
    client.connect_timeout = timeout
  end

end
