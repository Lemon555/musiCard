# frozen_string_literal: true

# Gets list of all songs of a search from API
class SearchAPIdb
  extend Dry::Monads::Either::Mixin

  def self.call(input)
    results = HTTP.get("#{Musicard.config.SPOTIFYSEARCH_API}/#{input}")
    Right(SongsRepresenter.new(Songs.new).from_json(results.body))
  rescue
    Left(Error.new('Our servers failed - we are investigating!'))
  end
end
