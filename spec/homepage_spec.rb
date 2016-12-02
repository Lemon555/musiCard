# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Homepage' do
  before do
    unless @browser
      # @headless = Headless.new
      @browser = Watir::Browser.new
    end
  end

  after do
    @browser.close
    # @headless.destroy
  end

  describe 'Page elements' do
    it '(HAPPY) should see website features' do
      # GIVEN
      @browser.goto homepage
      @browser.title.must_include 'musiCard'
      @browser.h1.text.must_include 'musiCard'

      # THEN
      @browser.button(id: 'search_btn').visible?.must_equal true
    end
  end

  describe 'Do a Search' do
    it '(HAPPY) should be able to search a new song' do
      # GIVEN: on the homepage
      @browser.goto homepage

      # WHEN: add a new search
      @browser.text_field(name: 'search_input').set(NEW_SEARCH)
      @browser.button(id: 'search_btn').click

      # THEN: song should be listed on homepage
      spotifywidget = @browser.iframe(class: 'group_url').last
      group_url_span.text.must_include 'analytics'
      group_url_span.a.href.must_include 'http'
      group_url_span.a.href.must_include 'analytics'
      group_name_span = @browser.spans(class: 'group_name').last
      group_name_span.text.must_include 'Analytics'

      # and danger flash notice should be seen
      flash_notice = @browser.div(class: 'alert')
      flash_notice.text.must_include 'added'
      flash_notice.attribute_value('class').must_include 'success'
    end
  end
end
