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

  include PageObject::PageFactory
  describe 'Page elements' do
    it '(HAPPY) should see website features' do
      # GIVEN
      visit Homepage do |page|
        page.heading.text.must_include 'musiCard'
        page.search_input.visible?.must_equal true
        page.search_btn.visible?.must_equal true
      end
    end
  end

  describe 'Do a Search' do
    it '(HAPPY) should be able to search a new song' do
      # GIVEN: on the homepage
      visit Homepage do |page|
        # WHEN: add a new search
        page.make_a_search(NEW_SEARCH)

        # THEN: song should be listed on homepage
        page.wait_for_music_players
        page.first_row.spotify_player_element.src.must_include NEW_TRACK_ID
        page.first_row.view_btn.visible?.must_equal true

        # and success flash notice should be seen
        page.flash_notice.must_include 'Success'
        page.flash_notice.attribute(:class).must_include 'success'

        # Modal test
        page.wait_for_image_preview_modal
        page.album_image_element.src.must_include 'https://i.scdn.co/'
        page.img_submit.visible?.must_equal true
      end
    end

    it '(HAPPY) should be able to search a exist song' do
      # GIVEN: on the homepage
      visit Homepage do |page|
        # WHEN: add an existing searching word
        page.make_a_search(EXISTS_SEARCH)

        # THEN: song should be listed on homepage
        page.wait_for_music_players
        page.first_row.spotify_player_element.src.must_include EXISTS_TRACK_ID
        page.first_row.view_btn.visible?.must_equal true

        # and success flash notice should be seen
        page.flash_notice.must_include 'Success'
        page.flash_notice.attribute(:class).must_include 'success'

        # Modal test
        page.wait_for_image_preview_modal
        page.album_image_element.src.must_include 'https://i.scdn.co/'
        page.img_submit.visible?.must_equal true
      end
    end

    it '(SAD) should alert user if cannot search' do
      # GIVEN: on the homepage
      visit Homepage do |page|
        # WHEN: add an existing searching word
        page.make_a_search(BAD_SEARCH)

        # and danger flash notice should be seen
        page.flash_notice.attribute(:class).must_include 'danger'
      end
    end
  end
end
