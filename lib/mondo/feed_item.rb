module Mondo
  class FeedItem < Resource

    attr_accessor :title,
                  :image_url,
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
        background_color: self.background_color,
        body: self.body,
      }
    end
  end
end