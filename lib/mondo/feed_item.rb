module Mondo
  class FeedItem < Resource

    attr_accessor :title,
                  :image_url,
                  :app_uri, # TODO - make me consistent when the Mondo API changes
                  :background_color,
                  :body


    # temporary fix until the API accepts data in the request body
    def save
      self.client.request(:post, "/feed", params: self.create_params)
    end

    def create_params
      {
        account_id: self.client.account_id,
        type: "image",
        title: self.title,
        image_url: self.image_url,
        app_uri: self.app_uri,
        background_color: self.background_color,
        body: self.body,
      }
    end
  end
end