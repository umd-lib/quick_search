require 'test_helper'

class QuickSearch::OpensearchControllerTest < ActionController::TestCase

  test "should return xml" do
    @request.env['HTTP_ACCEPT'] = 'application/xml'
    get :opensearch, use_route: :quick_search

    assert_response :success
    assert_select 'OpenSearchDescription'
  end

end
