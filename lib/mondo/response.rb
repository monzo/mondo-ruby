module Mondo
  class Response
    attr_reader   :response, :headers, :status, :body
    attr_accessor :error, :options

    # Initializes a Response instance
    #
    # @param [Faraday::Response] response The Faraday response instance
    def initialize(response)
      @response = response
      @headers  = response.headers
      @status   = response.status
      @body     = response.body || ''
    end

    def parsed_response
      @parsed_response ||= begin
        MultiJson.load(body)
      rescue MultiJson::ParseError
        body
      end
    end
  end
end
