# frozen_string_literal: true

# Gets list of all songs of a search from API
class SearchAPIdb
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(input)
    Dry.Transaction(container: self) do
      step :split_sentence
      step :call_api_to_get_existed_songs
    end.call(input)
  end

  register :split_sentence, lambda { |input|
    begin
      words = []
      if input.include? '%20'
        words = input.split('%20')
        words.unshift(input)
        # unshift will add a new item to the beginning of an array.
      else
        words.push(input)
      end
      Right(words)
    rescue
      Left(Error.new('Failed to split the input sentence!'))
    end
  }

  register :call_api_to_get_existed_songs, lambda { |search_terms|
    begin
      songs_arr = []
      search_terms.each do |word|
        result = HTTP.get("#{Musicard.config.SPOTIFYSEARCH_API}/#{word}")
        songs_arr.push(SongsRepresenter.new(Songs.new).from_json(result.body))
      end
      Right(songs_arr)
    rescue
      Left(Error.new('(get) Our servers failed - we are investigating!'))
    end
  }
end
