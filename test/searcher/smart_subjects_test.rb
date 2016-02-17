require 'test_helper'

class SmartSubjectsSearcherTest < ActiveSupport::TestCase

  setup do
    @subjects = Quicksearch::SmartSubjectsSearcher.new(HTTPClient.new, 'chemistry', 3)
  end

  test "should have http client, query, and per_page" do
    assert @subjects.http.is_a? HTTPClient
    assert @subjects.q == 'chemistry'
    assert_equal 3, @subjects.per_page
  end

  vcr_test "should have raw result", 'searches', cassette: 'smart_subjects_chemistry' do
    raw_results = @subjects.search
    assert raw_results['responseHeader']
  end

  vcr_test "should have parsed results", 'searches', cassette: 'smart_subjects_chemistry' do
    @subjects.search
    parsed_results = @subjects.results
    assert parsed_results.first.title.include?('Biochemistry')
    assert parsed_results.first.link.include?('subject=13')
  end

end
