module QuickSearch
  class Engine < ::Rails::Engine
    isolate_namespace QuickSearch

    initializer :quick_search, :after => :add_view_paths do
      config_file = File.join(Rails.root, "/config/quick_search_config.yml")
      if File.exist?(config_file)
        APP_CONFIG = YAML.load_file(config_file)[Rails.env]
        ActiveSupport.on_load(:action_controller) do
          theme_engine_class = "#{QuickSearch::Engine::APP_CONFIG['theme'].classify}::Engine".constantize
          prepend_view_path theme_engine_class.root.join('app', 'views', QuickSearch::Engine::APP_CONFIG['theme'])
        end
      else
        raise StandardError, "QuickSearch requires a configuration file called /config/quick_search_config.yml to run"
      end
    end

    initializer :best_bets, :after => :quick_search do
      if QuickSearch::Engine::APP_CONFIG['best_bets']['solr_url'].empty?
        best_bets_file = File.join(Rails.root, "/config/best_bets.yml")
        if File.exist?(best_bets_file)
          QuickSearch::Engine::BEST_BETS = YAML.load_file(best_bets_file)['best_bets']
          QuickSearch::Engine::BEST_BETS_INDEX = {}
          QuickSearch::Engine::BEST_BETS.each do |best_bet_name, best_bet|
            best_bet['keywords'].each do |keyword|
              QuickSearch::Engine::BEST_BETS_INDEX[keyword.downcase] = best_bet_name
            end
          end
        end
      end
    end
  end
end
