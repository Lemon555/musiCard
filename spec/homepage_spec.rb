# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Homepage' do
  before do
    unless @browser
      @headless = Headless.new
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
      spotifywidget = @browser.iframe(id: 'track_1')
      spotifywidget.src.must_include '76hfruVvmfQbw0eYn1nmeC'
      view_btn = @browser.button(id: 'track_1')
      view_btn.visible?.must_equal true

      # and danger flash notice should be seen
      flash_notice = @browser.div(class: 'alert')
      flash_notice.text.must_include 'Success'
      flash_notice.attribute_value('class').must_include 'success'

      # Modal test
      view_btn.click
      Watir::Wait.until { @browser.div(class: 'modal-dialog').visible? }
      @browser.img.attribute_value('src').must_include 'https://i.scdn.co/'
    end

    it '(HAPPY) should be able to search a exist song' do
      # GIVEN: on the homepage
      @browser.goto homepage

      # WHEN: add an existing group url
      @browser.text_field(name: 'search_input').set(EXISTS_SEARCH)
      @browser.button(id: 'search_btn').click

      # THEN: song should be listed on homepage
      spotifywidget = @browser.iframe(id: 'track_1')
      spotifywidget.src.must_include '23L5CiUhw2jV1OIMwthR3S'
      view_btn = @browser.button(id: 'track_1')
      view_btn.visible?.must_equal true

      # and danger flash notice should be seen
      flash_notice = @browser.div(class: 'alert')
      flash_notice.text.must_include 'Success'
      flash_notice.attribute_value('class').must_include 'success'

      # Modal test
      view_btn.click
      Watir::Wait.until { @browser.div(class: 'modal-dialog').visible? }
      @browser.img.attribute_value('src').must_include 'https://i.scdn.co/'
    end

    it '(SAD) should alert user if cannot search' do
      # GIVEN: on the homepage
      @browser.goto homepage

      # WHEN: add a badly formed group url
      @browser.text_field(name: 'search_input').set(BAD_SEARCH)
      @browser.button(id: 'search_btn').click

      # THEN: danger flash notice should be seen
      flash_notice = @browser.div(class: 'alert')
      flash_notice.attribute_value('class').must_include 'danger'
    end
  end
end
