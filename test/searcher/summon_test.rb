require 'test_helper'

class SummonSearcherTest < ActiveSupport::TestCase

  # FIXME: this test should be moved to a result set object
  vcr_test "should have author in result", "searches", cassette: 'printing' do
    summon = QuickSearch::SummonSearcher.new(HTTPClient.new, 'printing', 3)
    summon.search
    results = summon.results
    assert results.first.description.include?('Although we live in the digital age')
  end

end
