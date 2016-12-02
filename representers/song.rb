# frozen_string_literal: true

# Represents overall group information for JSON API output
class SongRepresenter < Roar::Decorator
  include Roar::JSON

  property :search_id
  property :track_name
  property :track_id
  property :artists
  property :album
  property :link
  property :images
end
