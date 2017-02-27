module QuickSearch

  ##
  # This class handles QuickSearch's internal logging of queries, events (clicks & serves), and sessions

  class LoggingController < ApplicationController

    include QuickSearch::OnCampus

    before_action :handle_session
    protect_from_forgery except: :log_event

    ##
    # Logs a search to the database
    #
    # This is an API endpoint for logging a search. It requires that at least a search query and a page are 
    # present in the query parameters. It returns a 200 OK HTTP status if the request was successful, or
    # an 400 BAD REQUEST HTTP status if any parameters are missing.

    def log_search
      if params[:query].present? && params[:page].present?
        @session.searches.create(query: params[:query], page: params[:page])
        head :ok
      else
        head :bad_request
      end
    end

    ##
    # Logs an event to the database. Typically, these can be clicks or serves.
    #
    # This is an API endpoint for logging an event. It requires that at least a TODO are 
    # present in the query parameters. It returns a 200 OK HTTP status if the request was successful, or
    # an 400 BAD REQUEST HTTP status if any parameters are missing. This endpoint supports JSONP requests.

    def log_event
      if params[:category].present? && params[:event_action].present? && params[:label].present?
        # if an action isn't passed in, assume that it is a click
        action = params.fetch(:action_type, 'click')

        # create a new event on the current session
        @session.events.create(category: params[:category], item: params[:event_action], query: params[:label][0..250], action: action)

        if params[:ga].present? and params[:ga]
          send_event_to_ga(params[:category], params[:event_action], params[:label])
        end

        # check whether this is a jsonp request
        if params[:callback].present?
          render :json => { 'response': 'success' }, :callback => params[:callback]
        else
          render :json => { 'response': 'success' }
        end
      else
        head :bad_request
      end
    end


    private

    ##
    # Logs an event to Google Analytics using the Measurement Protocol API
    # https://developers.google.com/analytics/devguides/collection/protocol/v1/

    def send_event_to_ga(category, action, label)
      # google_analytics_client_id is a UUID that identifies a particular client to the GA Measurement Protocol API
      if QuickSearch::Engine::APP_CONFIG['google_analytics_tracking_id'].blank? or QuickSearch::Engine::APP_CONFIG['google_analytics_client_id'].blank?
        return false
      end

      # Pass along the client user agent and IP address so it is associated
      # with the event in Google Analytics
      params = {
          v: 1,
          t: 'event',
          tid: QuickSearch::Engine::APP_CONFIG['google_analytics_tracking_id'],
          cid: QuickSearch::Engine::APP_CONFIG['google_analytics_client_id'],
          ec: category,
          ea: action,
          el: label,
          uip: request.remote_ip,
          ua: request.user_agent,
      }
  
      client = HTTPClient.new
      url = "https://www.google-analytics.com/collect?" + params.to_query

      # The measurement protocol API does not validate responses.
      # The best way to test this is testing the query string against:
      # https://ga-dev-tools.appspot.com/hit-builder/

      client.post(url)

    end

    ##
    # Handles creating/updating a session on every request

    def handle_session
      if is_existing_session?
        update_session
      else
        new_session
      end
    end

    ##
    # Returns true if current request has an existing session, false otherwise

    def is_existing_session?
      cookies.has_key? :session_id and Session.find_by(session_uuid: cookies[:session_id])
    end

    ##
    # Returns true if current request was from a mobile device
    #
    # Uses User-Agent from request to make the determination, which may not be all-encompassing
    # but works for most modern devices/browsers (iOS, Android). Looks for the string "Mobi" within
    # the user-agent, which normally contains either Mobi or Mobile if the request was from a mobile browser

    def is_mobile?
      # TODO: better test for mobile?
      # Recommended here as simple test: https://developer.mozilla.org/en-US/docs/Web/HTTP/Browser_detection_using_the_user_agent
      request.user_agent.include? "Mobi"
    end

    ##
    # Creates a new session, and logs it in the database
    #
    # A session is tracked by a UUID that is stored in a cookie, and has a 5 minute expiry time.
    # Sessions are stored in the database with the time they were initiated, their expiry time (or end time),
    # whether the request originated from a campus IP address, and whether the request originated from a mobile device

    def new_session
      on_campus = on_campus?(request.remote_ip)
      is_mobile = is_mobile?
      session_expiry = 5.minutes.from_now
      session_uuid = SecureRandom.uuid

      # create session in db
      @session = Session.create(session_uuid: session_uuid, expiry: session_expiry, on_campus: on_campus, is_mobile: is_mobile)
      # set cookie
      cookies[:session_id] = { :value => session_uuid, :expires => session_expiry }
    end

    ##
    # Updates a session's expiration time on cookie and in database
    #
    # When a request is made with a non-expired session, the expiration time is updated to 5 minutes from the current time.
    # This update is reflected in the cookie as well as in the database entry for the session.

    def update_session
      # update session expiry in the database
      session_id = cookies[:session_id]
      @session = Session.find_by session_uuid: session_id
      @session.expiry = 5.minutes.from_now
      @session.save

      # update session expiry on cookie
      cookies[:session_id] = { :value => session_id, :expires => @session.expiry }
    end

  end
end
