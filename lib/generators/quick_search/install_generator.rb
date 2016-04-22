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

      desc 'insert generic theme'
      def insert_theme
        theme_gem_entry = <<-THEME
\n\n
# -Inserted by QuickSearch-

# QuickSearch theme
#
# Remove the following if you want to use a different theme

gem 'quick_search_generic_theme', git: 'git@github.com:ncsu-libraries/quick_search-generic_theme.git'

# QuickSearch searchers
#
# If you want to use different searchers, remove/replace these and be sure to remove them from
# your config/quick_search_config.yml file as well as references to them in your theme's search
# results page template

gem 'quick_search_wikipedia_searcher', git: 'git@github.com:ncsu-libraries/quick_search-wikipedia_searcher.git'
gem 'quick_search_open_library_searcher', git: 'git@github.com:ncsu-libraries/quick_search-open_library_searcher.git'
gem 'quick_search_arxiv_searcher', git: 'git@github.com:ncsu-libraries/quick_search-arxiv_searcher.git'
gem 'quick_search_placeholder_searcher', git: 'git@github.com:ncsu-libraries/quick_search-placeholder_searcher.git'

# -END Inserted by QuickSearch-

        THEME
        insert_into_file "Gemfile", theme_gem_entry, :after => /gem [\"\']quick_search-core[\"\'].*$/
      end

      desc 'bundle install theme/searchers'
      def bundle_install_theme_searchers
        Bundler.with_clean_env do
          run "bundle install"
        end
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
