require 'test_helper'

class SmartSubjectsSearchTest < ActionDispatch::IntegrationTest
  vcr_test "should show smart subjects results", 'searches', cassette: 'printing' do
    visit root_path(q: 'printing')
    assert page.has_content?('Textile Chemistry')
  end
end