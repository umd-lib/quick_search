class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :prepend_view_paths

   def prepend_view_paths
     theme_engine_class = "#{APP_CONFIG['theme'].classify}::Engine".constantize
     prepend_view_path theme_engine_class.root.join('app', 'views', APP_CONFIG['theme'])
   end
end
