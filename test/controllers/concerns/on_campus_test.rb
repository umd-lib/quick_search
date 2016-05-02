require 'test_helper'

class OnCampusTest < ActionController::TestCase

  include QuickSearch::OnCampus

  test "should be on campus" do
    ip = '152.14.1.1'
    on_campus = on_campus?(ip)
    assert on_campus
  end

  test "should not be on campus" do
    ip = '152.2.1.1'
    on_campus = on_campus?(ip)
    assert_not on_campus
  end

end
