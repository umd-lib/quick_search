require 'test_helper'

class LandingPageTest < ActionDispatch::IntegrationTest
  test "should have a search box" do
    visit root_path
    assert page.has_selector?('#main-search-form')
  end
end
