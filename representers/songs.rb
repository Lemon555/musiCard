# frozen_string_literal: true

# Represents search results
require_relative 'song'

# Represents overall song information for JSON API output
class SongsRepresenter < Roar::Decorator
  include Roar::JSON

  collection :songs,
             extend: SongRepresenter,
             class: Song
end
