module Mondo
  class Attachment < Resource
    FIELDS = [
      :id, :user_id, :external_id,
      :file_url, :file_type,
      :url, :type
    ]

    attr_accessor *FIELDS
    date_accessor :created

    def register
      if @id
      	raise ClientError.new("You have already registered this attachment")
      end

    	self.client.api_post("attachment/register", registration_data)
    end

    def deregister
      self.client.api_post("attachment/deregister", id: @id)
    end

    def registration_data
      {
        external_id: @external_id,
        file_url:    @file_url,
        file_type:   @file_type,
      }
    end
  end
end
