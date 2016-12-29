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
      if input.include? '%20'
        words = input.split('%20')
        words.unshift(input)
        # unshift will add a new item to the beginning of an array.
      else
        words = []
        words.push(input)
      end
      Right(words)
    rescue
      Left(Error.new('Failed to split the input sentence!'))
    end
  }

  register :call_api_to_get_existed_songs, lambda { |search_terms|
    begin
      search_result = async_get_call(search_terms)
      songs_arr = search_result.map do |songs|
        SongsRepresenter.new(Songs.new).from_json(songs.body)
      end
      Right(songs_arr)
    rescue
      Left(Error.new('(get) Our servers failed - we are investigating!'))
    end
  }

  private_class_method

  def self.async_get_call(search_terms)
    promised_searches = search_terms.map do |word|
      Concurrent::Promise.execute do
        HTTP.get("#{Musicard.config.SPOTIFYSEARCH_API}/#{word}")
      end
    end
    promised_searches.map(&:value)
  end
end
