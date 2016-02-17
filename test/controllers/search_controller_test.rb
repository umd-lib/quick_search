require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  vcr_test "should return a summon searcher" do
    get :index, q: 'printing'
    assert assigns(:summon)
  end

  test "should redirect to link resolver" do
    get :index, q: 'doi:10.1002/0470841559.ch1'
    assert_redirected_to 'http://js8lb8ft5y.search.serialssolutions.com/criteriarefiner/?SS_doi=10.1002/0470841559.ch1'
  end

end
