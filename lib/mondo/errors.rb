require 'multi_json'

module Mondo
  class Error < StandardError
  end

  class ApiError < Error
    attr_reader :response, :code, :description

    def initialize(response)
      @response = response
      @code = response.status

      puts response.inspect if ENV['DEBUG']

      begin
        parsed_response = MultiJson.decode(response.body)
        errors = parsed_response["message"]
        @description = stringify_errors(errors)
      rescue MultiJson::ParseError
        @description = response.body ? response.body.strip : "Unknown error"
      end
    end

    def to_s
      "#{super}. #{self.description}"
    end

    private

    def stringify_errors(errors)
      case errors
      when Array
        errors.join(", ")
      when Hash
        errors.flat_map do |field, messages|
          messages.map { |message| "#{field} #{message}" }
        end.join(", ")
      else
        errors.to_s
      end
    end
  end

  class ClientError < Error
  end

  class SignatureError < Error
  end
end
