# A sample Guardfile
# More info at https://github.com/guard/guard#readme

group :livereload do
  guard 'livereload' do
    watch(%r{app/searchers/quick_search/.+\.rb})
    watch(%r{app/controllers/quick_search/.+\.rb})
    watch(%r{app/views/quick_search/.+\.(erb|haml|slim)$})
    watch(%r{app/helpers/quick_search/.+\.rb})
    watch(%r{public/.+\.(css|js|html)})
    watch(%r{config/locales/.+\.yml})
    # Rails Assets Pipeline
    watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|js|html))).*}) { |m| "/assets/#{m[3]}" }
  end
end

group :test do
  guard :minitest do
    # FIXME: add a callback that adds a separator on each test run
    # Rails 4
    watch(%r{^app/(.+)\.rb})                              { 'test' } #{ |m| "test/#{m[1]}_test.rb" }
    watch(%r{^app/controllers/quick_search/application_controller\.rb}) { 'test' }#{ 'test/controllers' }
    watch(%r{^app/controllers/quick_search/(.+)_controller\.rb})       { 'test' } #{ |m| "test/integration/#{m[1]}_test.rb" }
    watch(%r{^app/views/quick_search/(.+)_mailer/.+})                  { 'test' } #{ |m| "test/mailers/#{m[1]}_mailer_test.rb" }
    watch(%r{^lib/(.+)\.rb})                               { 'test' } #{ |m| "test/lib/#{m[1]}_test.rb" }
    watch(%r{^test/.+_test\.rb})
    watch(%r{^test/test_helper\.rb}) { 'test' }
  end
end
