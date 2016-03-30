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
