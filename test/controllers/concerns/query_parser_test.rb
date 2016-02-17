require 'test_helper'

class QueryParserTest < ActionController::TestCase

  include QueryParser

  test "should extract basic prefixed scoped query" do
    full_query = 'scope:scrc libraries'
    
    query = extracted_query(full_query)
    assert_equal('libraries', query)

    scope = extracted_scope(full_query)
    assert_equal('scrc', scope)
  end

  test "should extract basic suffixed scoped query" do
    full_query = 'libraries scope:scrc'
    
    query = extracted_query(full_query)
    assert_equal('libraries', query)

    scope = extracted_scope(full_query)
    assert_equal('scrc', scope)
  end

  test "should extract compound prefixed scoped query" do
    full_query = 'scope:(scrc OR jobs) libraries'
    
    query = extracted_query(full_query)
    assert_equal('libraries', query)

    scope = extracted_scope(full_query)
    assert_equal('scrc OR jobs', scope)
  end

  test "should extract compound suffixed scoped query" do
    full_query = 'libraries scope:(scrc OR jobs)'
    
    query = extracted_query(full_query)
    assert_equal('libraries', query)

    scope = extracted_scope(full_query)
    assert_equal('scrc OR jobs', scope)
  end

end