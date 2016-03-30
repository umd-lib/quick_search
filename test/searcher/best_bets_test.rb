require 'test_helper'

class BestBetsSearcherTest < ActiveSupport::TestCase

  setup do
    @best_bets = QuickSearch::BestBetsSearcher.new(HTTPClient.new, 'printing', 1)
    @best_bets_journal = QuickSearch::BestBetsSearcher.new(HTTPClient.new, 'journal of cell science', 1)
    @best_bets_database = QuickSearch::BestBetsSearcher.new(HTTPClient.new, 'encyclopedia of life sciences', 1)
  end

  test "should have http client, query, and per_page" do
    assert @best_bets.http.is_a? HTTPClient
    assert @best_bets.q == 'printing'
    assert_equal 1, @best_bets.per_page
  end

  vcr_test "should have parsed results", 'searches', cassette: 'best_bets_printing' do
    @best_bets.search
    parsed_results = @best_bets.results
    assert parsed_results.first.title.include?('Print')
  end

  vcr_test "should have journal result", 'searches', cassette: 'best_bets_journal' do
    @best_bets_journal.search
    parsed_results = @best_bets_journal.results
    assert parsed_results.first.title.include?('Journal of cell science')
  end

  vcr_test "should have database result", 'searches', cassette: 'best_bets_database' do
    @best_bets_database.search
    parsed_results = @best_bets_database.results
    assert parsed_results.first.title.include?('Encyclopedia of life sciences')
  end

end
