require 'test_helper'

class CatalogSearcherTest < ActiveSupport::TestCase

  setup do
    @catalog = Quicksearch::CatalogSearcher.new(HTTPClient.new, 'printing', 3)
  end

  test "should have http client, query, and per_page" do
    assert @catalog.http.is_a? HTTPClient
    assert @catalog.q == 'printing'
    assert_equal 3, @catalog.per_page
  end

  vcr_test "should have raw result", 'searches', cassette: 'catalog_printing' do
    raw_results = @catalog.search
    assert raw_results.children.first.name == 'searchResponse'
    #assert raw_results['searchResponse']
  end

  vcr_test "should have parsed results", 'searches', cassette: 'catalog_printing' do
    @catalog.search
    parsed_results = @catalog.results
    assert parsed_results.first.title.include?('Federal printing : overview and selected issues')
  end

  # # FIXME: this test should be moved to a result set object
  # vcr_test "should have raw search results", "searches", cassette: 'printing' do
  #   summon = Quicksearch::SummonSearcher.new(HTTPClient.new, 'printing', 3)
  #   summon.search
  #   results = summon.results
  #   assert results.first.description.include?('Although we live in the digital age')
  # end

end
