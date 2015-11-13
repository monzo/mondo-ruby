module Mondo
  class Attachment < Resource
    attr_accessor :id, :user_id, :external_id, :file_url, :file_type
    
    date_accessor :created


    def register
    	raise  ClientError.new("You have already registered this attachment") unless self.id.nil?

    	self.client.api_post("attachment/register", registration_data)
    end

    def deregister
      self.client.api_post("attachment/deregister", id: self.id)
    end

    def registration_data
      {
        external_id: self.external_id,
        file_url: self.file_url,
        file_type: self.file_type, 
      }
    end
  end
end