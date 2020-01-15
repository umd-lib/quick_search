# StandardError wrapper that enables the affected searcher to be specified
module QuickSearch
  class SearcherError < StandardError
    attr_reader :searcher

    def initialize(e=nil, searcher)
      super e
      @searcher = searcher
      set_backtrace e.backtrace if e
    end
  end
end