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
      http_result = HTTP.post("#{Musicard.config.SPOTIFYSEARCH_API}/#{input}")
      Right(input: input, http_result: http_result)
    rescue
      Left(Error.new('Our servers failed - we are investigating!'))
    end
  }

  register :return_api_result, lambda { |params|
    flag = false
    params.each do |http_result|
      if http_result.status != 200 && http_result.status != 422
        search = http_result.body.to_s
        @message = ErrorFlattener.new(
          ApiErrorRepresenter.new(ApiError.new).from_json(search)
        ).to_s
        break
      else
        flag = true
      end
    end
    flag ? Right('Success') : Left(Error.new(@message))
  }
end
