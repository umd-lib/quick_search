require 'test_helper'

class OpensearchControllerTest < ActionController::TestCase

  test "should return xml" do
    @request.env['HTTP_ACCEPT'] = 'application/xml'
    get :opensearch

    assert_response :success
    assert_select 'OpenSearchDescription'
  end

end
