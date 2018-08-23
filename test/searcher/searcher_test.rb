require 'test_helper'

class SearcherTest < ActiveSupport::TestCase
  def setup
    # Clear any "test_search" setting in I18N
    I18n.backend.store_translations(:en, {test_search: {loaded_link: nil} })
  end

  test 'module_link_on_error should return nil on StandardError if no I18N value is given' do
    error = StandardError.new
    module_link = QuickSearch::Searcher.module_link_on_error('test', error, '_sample_query')
    assert module_link.nil?
  end

  test 'module_link_on_error should return I18N value on StandardError' do
    I18n.backend.store_translations(:en, {test_search: {loaded_link: 'from I18N'} })
    error = StandardError.new
    module_link = QuickSearch::Searcher.module_link_on_error('test', error, '_sample_query')
    assert_equal 'from I18N_sample_query', module_link
  end

  test 'module_link_on_error should return I18N value if present on SearcherError' do
    I18n.backend.store_translations(:en, {test_search: {loaded_link: 'from I18N'} })
    searcher = SearcherTest::TestSearcher.new
    error = QuickSearch::SearcherError.new(StandardError.new, searcher)
    module_link = QuickSearch::Searcher.module_link_on_error('test', error, '_sample_query')
    assert_equal 'from I18N_sample_query', module_link
  end

  test 'module_link_on_error should use loaded_link method if I18N value is not present on SearcherError' do
    searcher = SearcherTest::TestSearcher.new
    error = QuickSearch::SearcherError.new(StandardError.new, searcher)
    module_link = QuickSearch::Searcher.module_link_on_error('test', error, 'sample query')
    assert_equal 'test_loaded_link', module_link
  end
end

# Simple test searcher
class SearcherTest::TestSearcher < QuickSearch::Searcher
  def initialize
  end

  def loaded_link
    'test_loaded_link'
  end
end
