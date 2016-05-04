require 'test_helper'

class BestBetsSearcherTest < ActiveSupport::TestCase

  setup do
    @best_bets = QuickSearch::BestBetsSearcher.new(HTTPClient.new, 'acm digital library', 1)
    @best_bets_eric = QuickSearch::BestBetsSearcher.new(HTTPClient.new, 'eric', 1)
  end

  test "should have http client, query, and per_page" do
    assert @best_bets.http.is_a? HTTPClient
    assert @best_bets.q == 'acm digital library'
    assert_equal 1, @best_bets.per_page
  end

  test "should fall back to local yml file if no solr url defined" do
    @best_bets_eric.search
    parsed_results = @best_bets_eric.results
    assert parsed_results.first.title.include?('ERIC (Educational Resource Information Center)')
  end

  vcr_test "should make request to solr if solr_url defined", 'searches', cassette: 'best_bets_acm' do
    QuickSearch::Engine::APP_CONFIG['best_bets']['solr_url'] = 'http://localhost:8983/solr/bestbets/select?'
    @best_bets.search
    parsed_results = @best_bets.results
    assert parsed_results.first.title.include?('ACM')
  end

end
