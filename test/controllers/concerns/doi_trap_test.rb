require 'test_helper'

class DoiTrapTest < ActionController::TestCase

  include DoiTrap

  test "should be a doi" do
    doi = '10.1016/0046-8177(95)90302-X'
    is_a_doi = is_a_doi?(doi)
    assert is_a_doi
  end

  test "should not be a doi" do
    doi = '0046-8177(95)90302-X'
    is_a_doi = is_a_doi?(doi)
    assert_not is_a_doi  
  end

end