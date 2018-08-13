module QuickSearch
  class Searcher
    attr_accessor :response, :results_list, :total, :http, :q, :per_page, :loaded_link, :offset, :page, :scope

    include QueryFilter

    # TODO: What should the method signature be?
    def initialize(http_client, q, per_page, offset = 0, page = 1, on_campus = false, scope = '', params = {})
      @http = http_client
      @q = q
      @per_page = per_page
      @page = page
      @offset = offset
      @on_campus = on_campus
      @scope = scope
    end

    # a search must
    def search
      raise # FIXME: pick some good error
    end

    # results must create a @results_list attribute
    def results
      raise #FIXME: pick some good error
    end

    # Returns a String representing the link to use when no results are
    # found for a search.
    #
    # This default implementation first looks for the "i18n_key" and
    # "default_i18n_key" in the I18N locale files. If no entry is found
    # the "no_results_link" from the searcher configuration is returned.
    #
    # Using the I18N locale files is considered legacy behavior (but
    # is preferred in this method to preserve existing functionality).
    # Use of the searcher configuration file is preferred.
    def no_results_link(service_name, i18n_key, default_i18n_key = nil)
      locale_result = I18n.t(i18n_key, default: I18n.t(default_i18n_key))
      return locale_result if locale_result

      begin
        config_class = "QuickSearch::Engine::#{service_name.upcase}_CONFIG".constantize
        config_class['no_results_link']
      rescue NameError
        nil
      end
    end

    private

    def http_request_queries
      query = @q.dup
      queries = {}

      query = filter_query(query)

      queries['not_escaped'] = query
      queries['uri_escaped'] = CGI.escape(query.to_str)
      queries['mysql_escaped'] = Mysql2::Client.escape(query)
      queries
    end

  end
end
