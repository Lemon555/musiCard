# frozen_string_literal: true
require_relative 'spec_helper'
require_relative 'pages/homepage_page.rb'

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

  include PageObject::PageFactory
  describe 'Page elements' do
    it '(HAPPY) should see website features' do
      # GIVEN
      visit Homepage do |page|
        page.header_link_element.text.must_include 'musiCard'
        page.heading.must_include 'Music with Quotes'
        page.search_input_element.visible?.must_equal true
        page.search_btn?.must_equal true
      end
    end
  end

  describe 'Do a Search' do
    it '(HAPPY) should be able to search a new song' do
      # GIVEN: on the homepage
      visit Homepage do |page|
        # WHEN: add a new search
        page.make_a_search(NEW_SEARCH)
        page.header_link_element.text.must_include 'musiCard'
        page.search_input_element.visible?.must_equal true
        page.search_btn?.must_equal true

        # THEN: song should be listed on homepage
        spotifywidget = @browser.iframe(id: 'track_0')
        spotifywidget.src.must_include NEW_TRACK_ID
        # page.first_music_player.src.must_include NEW_TRACK_ID
        page.first_row.view_btn?.must_equal true

        # Modal test
        page.wait_for_image_preview_modal
        page.album_image_element.attribute(:src).must_include HEAD_OF_IMAGE
        page.img_submit?.must_equal true
      end
    end

    it '(HAPPY) should be able to search a exist song' do
      # GIVEN: on the homepage
      visit Homepage do |page|
        # WHEN: add an existing searching word
        page.make_a_search(EXISTS_SEARCH)
        page.header_link_element.text.must_include 'musiCard'
        page.search_input_element.visible?.must_equal true
        page.search_btn?.must_equal true

        # THEN: song should be listed on homepage
        spotifywidget = @browser.iframe(id: 'track_1')
        spotifywidget.src.must_include EXISTS_TRACK_ID
        # page.first_music_player.src.must_include EXISTS_TRACK_ID
        page.first_row.view_btn?.must_equal true

        # Modal test
        page.wait_for_image_preview_modal
        page.album_image_element.attribute(:src).must_include HEAD_OF_IMAGE
        page.img_submit?.must_equal true
      end
    end

    it '(SAD) should alert user if cannot search' do
      # GIVEN: on the homepage
      visit Homepage do |page|
        # WHEN: add an existing searching word
        page.make_a_search(BAD_SEARCH)

        # and danger flash notice should be seen
        page.flash_notice_element.attribute(:class).must_include 'danger'
      end
    end
  end
end
