# frozen_string_literal: true

# Gets list of all groups from API
class CreateNewSearch
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(input)
    Dry.Transaction(container: self) do
      step :split_sentence
      step :call_api_to_search
      step :return_api_result
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

  register :call_api_to_search, lambda { |search_terms|
    begin
      search_result = async_post_call(search_terms)
      Right(search_result)
    rescue
      Left(Error.new('(create) Our servers failed - we are investigating!'))
    end
  }

  register :return_api_result, lambda { |params|
    begin
      params.each do |http_result|
        if http_result.status != 200 || http_result.status != 422
          search = http_result.body.to_s
          @message = ErrorFlattener.new(
            ApiErrorRepresenter.new(ApiError.new).from_json(search)
          ).to_s
          break
        end
      end
      Right('Success')
    rescue
      Left(Error.new(@message))
    end
  }

  private_class_method

  def self.async_post_call(search_terms)
    promised_searches = search_terms.map do |word|
      Concurrent::Promise.execute do
        HTTP.post("#{Musicard.config.SPOTIFYSEARCH_API}/#{word}")
      end
    end
    promised_searches.map(&:value)
  end
end
