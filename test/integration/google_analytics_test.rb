require 'test_helper'

class GoogleAnalyticsTest < ActionDispatch::IntegrationTest
  
  # FIXME maybe should use puffing-billy gem for this?
  setup do
    WebMock.disable!
    Capybara.current_driver = Capybara.javascript_driver
    visit root_path(q: 'printing')
  end

  test "should capture google analytics data for all links in module" do
    within("#catalog") do
      click_link('Books & Media')
    end
    assert page.has_content?('heading')

    click_link('book results')
    assert page.has_content?('see-all-results')

  end

end