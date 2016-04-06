module Mondo
  class WebHook < Resource

    attr_accessor :id, :account_id, :url

    def save
    	self.client.api_post("webhooks", account_id: account_id, url: url)
    end

    def delete
      self.client.api_delete("webhooks/%i" % self.id)
      true
    end

  end
end
