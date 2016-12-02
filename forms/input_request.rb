# frozen_string_literal: true

InputRequest = Dry::Validation.Form do
  required(:search_input).filled(:str?)

  configure do
    config.messages_file = File.join(__dir__, 'errors/input_request.yml')
  end
end
