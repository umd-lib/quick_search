require 'test_helper'

class SearchingTest < ActionDispatch::IntegrationTest

  vcr_test "included searchers should appear on results page", "searches", cassette: 'printing' do
    visit root_path(:q => 'printing')
    assert page.assert_text('Wikipedia')
    assert page.has_content?('OpenLibrary')
    assert page.has_content?('arXiv')
    assert page.has_content?('Placeholder')
  end

  vcr_test "should have wikipedia results", "searches", cassette: 'hunt_library' do
    visit root_path(:q => 'James B. Hunt Jr. Library')
    assert page.has_content?('James B. Hunt Jr. Library')
  end

  vcr_test "should present a spelling suggestion", "searches", cassette: 'speling' do
    visit root_path(:q => 'speling')
    assert page.has_content?('Did you mean')
  end

  vcr_test "should have Open Library results", "searches", cassette: 'harry potter' do
    visit root_path(:q => 'harry potter')
    assert page.has_content?('Harry Potter')
  end

end
