require 'test_helper'

class EmatrixDatabaseSearcherTest < ActiveSupport::TestCase

  setup do
    @database = Quicksearch::EmatrixDatabaseSearcher.new(HTTPClient.new, 'chemistry', 3)
  end

  test "should have http client, query, and per_page" do
    assert @database.http.is_a? HTTPClient
    assert @database.q == 'chemistry'
    assert_equal 3, @database.per_page
  end

  vcr_test "should have raw result", 'searches', cassette: 'ematrix_database_chemistry' do
    raw_results = @database.search
    assert raw_results.is_a?(Nokogiri::XML::Document)
  end

  vcr_test "should have parsed results", 'searches', cassette: 'ematrix_database_chemistry' do
    @database.search
    parsed_results = @database.results
    assert parsed_results.first.title.include?('Encyclopedia of analytical chemistry')
    assert parsed_results.first.link.include?('proxying.lib.ncsu.edu')
  end

end
