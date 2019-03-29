require 'test_helper'
require_dependency 'searcher_error'

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

  test 'no_results_link should use "no_results_link" method if I18N value is not present' do
    # Set Searcher Configuration value
    QuickSearch::Engine::TEST_CONFIG = { 'no_results_link' => 'from config' }

    # Enable I18n fallback (simulates config.i18n.fallbacks=true)
    I18n::Backend::Simple.include(I18n::Backend::Fallbacks)
    I18n.fallbacks= {:en=>[:en]}

    # I18n key is not in I18n configuration
    searcher = SearcherTest::TestSearcher.new
    no_results_link = searcher.no_results_link('test', 'test_search.no_results_link')
    assert_equal 'from config', no_results_link

    # I18n key is nil
    searcher = SearcherTest::TestSearcher.new
    no_results_link = searcher.no_results_link('test', nil)
    assert_equal 'from config', no_results_link

    # I18n default key is not in I18n configuration
    searcher = SearcherTest::TestSearcher.new
    no_results_link = searcher.no_results_link(
      'test', 'test_search.no_results_link', 'test_search.default_no_results_link')
    assert_equal 'from config', no_results_link

    # I18n default key is nil
    searcher = SearcherTest::TestSearcher.new
    no_results_link = searcher.no_results_link('test', nil, nil)
    assert_equal 'from config', no_results_link
  end

  test 'no_results_link should use I18N value if present' do
    # Set Searcher Configuration value
    QuickSearch::Engine::TEST_CONFIG = { 'no_results_link' => 'from config' }

    # Set I18N value
    I18n.backend.store_translations(:en,
      {test_search: {no_results_link: 'from I18N', default_no_results_link: 'from default I18N'} })

    # When default I18N key is not specified
    searcher = SearcherTest::TestSearcher.new
    no_results_link = searcher.no_results_link('test', 'test_search.no_results_link')
    assert_equal 'from I18N', no_results_link

    # When default I18N key is specified, and exists
    searcher = SearcherTest::TestSearcher.new
    no_results_link = searcher.no_results_link(
      'test', 'test_search.no_results_link', 'test_search.default_no_results_link')
    assert_equal 'from I18N', no_results_link
  end

  test 'no_results_link should use default I18N value if present and I8N value is not present' do
    # Set Searcher Configuration value
    QuickSearch::Engine::TEST_CONFIG = { 'no_results_link' => 'from config' }

    # Set default I18N value
    I18n.backend.store_translations(:en, {test_search: {default_no_results_link: 'from default I18N'} })

    searcher = SearcherTest::TestSearcher.new

    # Test i18n_key does not exist
    no_results_link = searcher.no_results_link(
      'test', 'nonexistent_i18n_key', 'test_search.default_no_results_link')
    assert_equal 'from default I18N', no_results_link

    # Test i18n_key is nil
    no_results_link = searcher.no_results_link(
      'test', nil, 'test_search.default_no_results_link')
    assert_equal 'from default I18N', no_results_link
  end

  def teardown
    # Clear TEST_CONFIG constant, if set
    QuickSearch::Engine.send(:remove_const, 'TEST_CONFIG') if defined? QuickSearch::Engine::TEST_CONFIG

    # Clear any I18n changes
    I18n.backend.reload!
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
