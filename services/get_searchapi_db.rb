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
      words = input.include?('%20') ? [input, input.split('%20')].flatten : [input]
      Right(words)
    rescue
      Left(Error.new('(Get) Failed to split the input sentence!'))
    end
  }

  register :call_api_to_get_existed_songs, lambda { |search_terms|
    begin
      search_result = async_get_call(search_terms)
      Right(result: search_result, search_terms: search_terms)
    rescue
      Left(Error.new('(get) Our servers failed - we are investigating!'))
    end
  }

  private_class_method

  def self.async_get_call(search_terms)
    promised_searches = search_terms.map do |word|
      Concurrent::Promise.execute do
        result = HTTP.get("#{Musicard.config.SPOTIFYSEARCH_API}/#{word}")
        SongsRepresenter.new(Songs.new).from_json(result.body)
      end
    end
    promised_searches.map(&:value)
  end
end
