require 'test_helper'

class CatalogSearchTest < ActionDispatch::IntegrationTest
  vcr_test "should show catalog results", 'searches', cassette: 'printing' do
    visit root_path(q: 'printing')
    assert page.has_content?('book results')
  end
end
