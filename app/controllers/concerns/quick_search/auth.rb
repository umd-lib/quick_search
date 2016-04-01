require "digest/md5"

module QuickSearch::Auth
  extend ActiveSupport::Concern

  SALT01 = SecureRandom.hex(512)
  SALT02 = SecureRandom.hex(512)
  REALM = "Please enter the username and password to access this page"
  USERS = {"#{QuickSearch::Engine::APP_CONFIG['user']}" => Digest::MD5.hexdigest(["#{QuickSearch::Engine::APP_CONFIG['user']}",REALM,"#{QuickSearch::Engine::APP_CONFIG['password']}"].join(":"))}
  SALTY = SALT01 + Digest::MD5.hexdigest(["#{QuickSearch::Engine::APP_CONFIG['user']}",REALM,"#{QuickSearch::Engine::APP_CONFIG['password']}"].join(":")) + SALT02

  def auth
    authenticate_or_request_with_http_digest(REALM) do |username|
      unless SALT01.blank? or SALT02.blank? or USERS[username].blank?
        if SALT01 + USERS[username] + SALT02 == SALTY
          USERS[username]
        end
      end
    end
  end

end
