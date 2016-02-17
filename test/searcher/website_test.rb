require 'test_helper'

class WebsiteSearcherTest < ActiveSupport::TestCase

  setup do
    @website = Quicksearch::WebsiteSearcher.new(HTTPClient.new, 'printing', 3)
  end

  test "should have http client, query, and per_page" do
    assert @website.http.is_a? HTTPClient
    assert @website.q == 'printing'
    assert_equal 3, @website.per_page
  end

  vcr_test "should have raw result", 'searches', cassette: 'website_printing' do
    raw_results = @website.search
    assert raw_results['responseHeader']
  end

  vcr_test "should have parsed results", 'searches', cassette: 'website_printing' do
    @website.search
    parsed_results = @website.results
    assert parsed_results.first.title.include?('Print')
  end

  # # FIXME: this test should be moved to a result set object
  # vcr_test "should have raw search results", "searches", cassette: 'printing' do
  #   summon = Quicksearch::SummonSearcher.new(HTTPClient.new, 'printing', 3)
  #   summon.search
  #   results = summon.results
  #   assert results.first.description.include?('Although we live in the digital age')
  # end

end
