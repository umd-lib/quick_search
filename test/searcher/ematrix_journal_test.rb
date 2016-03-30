require 'test_helper'

class EmatrixJournalSearcherTest < ActiveSupport::TestCase

  setup do
    @journal = QuickSearch::EmatrixJournalSearcher.new(HTTPClient.new, 'chemistry', 3)
  end

  test "should have http client, query, and per_page" do
    assert @journal.http.is_a? HTTPClient
    assert @journal.q == 'chemistry'
    assert_equal 3, @journal.per_page
  end

  vcr_test "should have raw result", 'searches', cassette: 'ematrix_journal_chemistry' do
    raw_results = @journal.search
    assert raw_results.is_a?(Nokogiri::XML::Document)
  end

  vcr_test "should have parsed results", 'searches', cassette: 'ematrix_journal_chemistry' do
    @journal.search
    parsed_results = @journal.results
    assert parsed_results.first.title.include?('Annual reports')
    assert parsed_results.first.link.include?('33000')
  end

end
