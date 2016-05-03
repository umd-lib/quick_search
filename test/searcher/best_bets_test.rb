require 'test_helper'

class BestBetsSearcherTest < ActiveSupport::TestCase

  setup do
    @best_bets = QuickSearch::BestBetsSearcher.new(HTTPClient.new, 'acm digital library', 1)
  end

  test "should have http client, query, and per_page" do
    assert @best_bets.http.is_a? HTTPClient
    assert @best_bets.q == 'acm digital library'
    assert_equal 1, @best_bets.per_page
  end

  vcr_test "should have parsed results", 'searches', cassette: 'best_bets_acm' do
    @best_bets.search
    parsed_results = @best_bets.results
    assert parsed_results.first.title.include?('ACM')
  end

end
