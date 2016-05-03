require 'test_helper'

class QuickSearch::SearchControllerTest < ActionController::TestCase

#  vcr_test "should return a summon searcher" do
#    get :index, q: 'printing'
#    assert assigns(:summon)
#  end

  test "should redirect to link resolver" do
    get :index, q: 'doi:10.1002/0470841559.ch1'
    assert_redirected_to 'http://doi.org/10.1002%2F0470841559.ch1'
  end

end
