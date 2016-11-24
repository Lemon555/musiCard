# frozen_string_literal: true

# Represents overall group information for JSON API output
class SongRepresenter < Roar::Decorator
  include Roar::JSON

  property :id
  property :image
end
