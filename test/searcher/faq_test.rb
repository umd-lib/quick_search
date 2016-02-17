require 'test_helper'

class FaqSearcherTest < ActiveSupport::TestCase

  setup do
    @faq = Quicksearch::FaqSearcher.new(HTTPClient.new, 'printing', 3)
  end

  test "should have http client, query, and per_page" do
    assert @faq.http.is_a? HTTPClient
    assert @faq.q == 'printing'
    assert_equal 3, @faq.per_page
  end

  # vcr_test "should have raw result", 'searches', cassette: 'faq_printing' do
  #   raw_results = @faq.search
  #   assert raw_results.is_a?(Sequel::MySQL::Dataset)
  # end

  # vcr_test "should have parsed results", 'searches', cassette: 'faq_printing' do
  #   @faq.search
  #   parsed_results = @faq.results
  #   assert parsed_results.first.title.include?('Print Quota')
  #   assert parsed_results.first.link.include?('274')
  # end

end