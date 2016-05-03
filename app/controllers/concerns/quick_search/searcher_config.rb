module QuickSearch::SearcherConfig
  extend ActiveSupport::Concern

  private

  def searcher_config(searcher)
    # Best Bets searcher is available in QuickSearch core, use app_config
    if searcher == 'best_bets'
      QuickSearch::Engine::APP_CONFIG['best_bets']
    else
      begin
        "QuickSearch::Engine::#{searcher.upcase}_CONFIG".constantize
      rescue NameError
        nil
      end
    end
  end

end
