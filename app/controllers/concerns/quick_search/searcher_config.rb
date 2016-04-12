module QuickSearch::SearcherConfig
  extend ActiveSupport::Concern

  private

  def searcher_config(searcher)
    #TODO: test for the existence of this?
    "QuickSearch::Engine::#{searcher.upcase}_CONFIG".constantize
  end

end
