require 'test_helper'

class SearchingTest < ActionDispatch::IntegrationTest

  vcr_test "search box should give search results", "searches", cassette: 'printing' do
    visit root_path
    within('#quicksearch') do
      fill_in :q, with: 'printing'
      click_on('Search')
      assert page.has_content?('Articles')
    end
  end

  vcr_test "should have article results", "searches", cassette: 'printing' do
    visit root_path
    within('#quicksearch') do
      fill_in :q, with: 'printing'
      click_on('Search')
      assert page.has_content?('Beginning Os X Lion Apps ')
    end
  end

  vcr_test "should present a spelling suggestion", "searches", cassette: 'speling' do
    visit root_path
    within('#quicksearch') do
      fill_in :q, with: 'speling'
      click_on('Search')
      assert page.has_content?('Did you mean')
    end
  end

  vcr_test "should have FAQ results", "searches", cassette: 'printing' do
    visit root_path
    within('#quicksearch') do
      fill_in :q, with: 'printing'
      click_on('Search')
      assert page.has_content?('Where is the Makerspace in Hunt Library')
    end
  end
end
