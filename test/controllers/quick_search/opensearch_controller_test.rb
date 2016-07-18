require 'test_helper'

class QuickSearch::OpensearchControllerTest < ActionController::TestCase
  include QuickSearch::Engine.routes.url_helpers

  setup do
    @routes = QuickSearch::Engine.routes
  end

  test "should return xml" do
    @request.env['HTTP_ACCEPT'] = 'application/xml'
    get :opensearch

    assert_response :success
    assert_select 'OpenSearchDescription'
  end

end
