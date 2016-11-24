# frozen_string_literal: true

# Gets list of all groups from API
class CreateNewSearch
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(input)
    Dry.Transaction(container: self) do
      step :call_api_to_search
      step :return_api_result
    end.call(input)
  end

  register :call_api_to_search, lambda { |input|
    begin
      Right(HTTP.post("#{Musicard.config.SPOTIFYSEARCH_API}/#{input}"))
    rescue
      Left(Error.new('Our servers failed - we are investigating!'))
    end
  }

  register :return_api_result, lambda { |http_result|
    data = http_result.body.to_s
    if http_result.status == 200
      Right(SongRepresenter.new(Song.new).from_json(data))
    else
      message = ErrorFlattener.new(
        ApiErrorRepresenter.new(ApiError.new).from_json(data)
      ).to_s
      Left(Error.new(message))
    end
  }
end
