# frozen_string_literal: true
# Page object for homepage
class Homepage
  include PageObject

  page_url 'http://localhost:9000/'

  h1(:heading)
  div(:flash_notice, class: 'alert')
  text_field(:search_input, name: 'search_input')
  button(:search_btn, id: 'search_btn')

  indexed_property(
    :music_players,
    [
      [:div, :result_row, { id: 'track_%s' }],
      # [:in_iframe, :spotify_player, { id: 'track_%s' }],
      [:button, :view_btn, { id: 'track_%s' }]
    ]
  )

  div(:image_preview, class: 'modal-dialog')
  image(:album_image, id: 'album_image')
  button(:img_submit, id: 'track-image-submit')

  def first_row
    music_players[0]
  end

  def first_music_player
    music_players[0].spotify_player_element
  end

  def wait_for_image_preview_modal
    first_row.view_btn
    wait_until { image_preview_element.visible? }
  end

  def make_a_search(input)
    self.search_input = input
    search_btn
  end
end
