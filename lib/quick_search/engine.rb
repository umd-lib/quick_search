module QuickSearch
  class Engine < ::Rails::Engine
    isolate_namespace QuickSearch

    initializer :quick_search, :after => :add_view_paths do
      config_file = File.join(Rails.root, "/config/quicksearch_config.yml")
      APP_CONFIG = YAML.load_file(config_file)[Rails.env]
      ActiveSupport.on_load(:action_controller) do
        theme_engine_class = "#{QuickSearch::Engine::APP_CONFIG['theme'].classify}::Engine".constantize
        prepend_view_path theme_engine_class.root.join('app', 'views', QuickSearch::Engine::APP_CONFIG['theme'])
      end
    end
  end
end
