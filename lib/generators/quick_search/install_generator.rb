module QuickSearch
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      desc 'insert routes'
      def insert_routes
        routes = <<-ROUTES
  mount QuickSearch::Engine => "/"
ROUTES
        insert_into_file "config/routes.rb", routes, :after => "Rails.application.routes.draw do\n"
      end

      desc 'create application configuration file'
      def quick_search_config_yml
        copy_file 'quick_search_config.yml', 'config/quick_search_config.yml'
      end

      desc 'create kaminari initializer'
      def kaminari_initializer
        copy_file 'kaminari.rb', 'config/initializers/kaminari.rb'
      end

      desc 'add styles'
      def add_styles
        remove_file 'app/assets/stylesheets/application.css'
        create_file 'app/assets/stylesheets/application.css.scss', %Q|@import "quick_search";\n|
      end

      desc 'add javascript'
      def add_javascript
        gsub_file('app/assets/javascripts/application.js', '//= require_tree .', '//= require quick_search')
      end

      desc 'install migrations'
      def install_migrations
        rake "quick_search:install:migrations"
        rake "db:migrate"
      end

      desc 'display messages about what needs to be configured'
      def configuration_messages
        file = File.read(File.join( File.expand_path('../templates', __FILE__), 'post_install.txt'))
        say file, :green
      end

    end
  end
end
