module Mondo
  class Response
    attr_reader :response, :parsed
    attr_accessor :error, :options

    # Initializes a Response instance
    #
    # @param [Faraday::Response] response The Faraday response instance
    def initialize(resp)
      @response = resp
      @parsed = -> { MultiJson.load(body) rescue body }.call
    end

    # The HTTP response headers
    def headers
      response.headers
    end

    # The HTTP response status code
    def status
      response.status
    end

    # The HTTP response body
    def body
      response.body || ''
    end
  end
end