module QuickSearch::SearcherConcern
  extend ActiveSupport::Concern

  include QuickSearch::OnCampus
  include QuickSearch::QueryParser
  include QuickSearch::EncodeUtf8
  include QuickSearch::SearcherConfig
  require 'benchmark_logger'
  require_dependency 'searcher_error'

  private

  def search_all_in_threads(primary_searcher = 'defaults')
    benchmark "%s server ALL" % CGI.escape(query.to_str) do
      search_threads = []
      @found_types = [] # add the types that are found to a navigation bar

      if primary_searcher == 'defaults'
        searchers = QuickSearch::Engine::APP_CONFIG['searchers']
      else
        searcher_config = searcher_config(primary_searcher)
        if searcher_config and searcher_config.has_key? 'with_paging'
          searchers = searcher_config['with_paging']['searchers']
        else
          searchers = [primary_searcher]
        end
      end

      # Constantize all searchers before creating searcher threads
      # Excluding this line causes threads to hang indefinitely as of Rails 5
      QuickSearch::Engine::APP_CONFIG['searchers'].each do |searcher_name|
        "QuickSearch::#{searcher_name.camelize}Searcher".constantize
      end

      searchers.shuffle.each do |search_method|
        search_threads << Thread.new(search_method) do |sm|
          benchmark "%s server #{sm}" % CGI.escape(query.to_str) do
            begin
              klass = "QuickSearch::#{sm.camelize}Searcher".constantize

              http_client = HTTPClient.new
              update_searcher_timeout(http_client, sm)
              # FIXME: Probably want to set paging and offset somewhere else.
              # searcher = klass.new(http_client, params_q_scrubbed, QuickSearch::Engine::APP_CONFIG['per_page'], 0, 1, on_campus?(request.remote_ip))
              if sm == primary_searcher
                if searcher_config.has_key? 'with_paging'
                  per_page = searcher_config['with_paging']['per_page']
                else
                  per_page = 10
                end
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

              # Wrap e in a SearcherError, so that the searcher object is
              # available for retrieval.
              searcher_error = QuickSearch::SearcherError.new(e, searcher)
              logger.info "FAILED SEARCH: #{sm} | #{params_q_scrubbed}"
              instance_variable_set :"@#{sm.to_s}", searcher_error
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
