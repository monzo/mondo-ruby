require 'multi_json'

module Mondo
  class Error < StandardError; end
  class ClientError < Error; end
  class SignatureError < Error; end

  class ApiError < Error
    include Utils::Errors

    attr_reader :response, :response_code, :description

    def initialize(response)
      @response      = response
      @response_code = response.status

      begin
        parsed_response = MultiJson.decode(response.body)
        errors = parsed_response["message"]

        @description = stringify_errors(errors)
      rescue MultiJson::ParseError
        @description = response.body ? response.body.strip : "Unknown error"
      end
    end

    def to_s
      "%s. %s" % [super, @description]
    end
  end
end
