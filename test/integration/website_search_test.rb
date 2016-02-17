require 'test_helper'

class WebsiteSearchTest < ActionDispatch::IntegrationTest
  vcr_test "should show website results", 'searches', cassette: 'printing' do
    visit root_path(q: 'printing')
    assert page.has_content?('Our Website')
  end
end