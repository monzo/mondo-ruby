module Mondo
  class FeedItem < Resource

    attr_accessor :title,
                  :image_url,
                  :url, # TODO - make me consistent when the Mondo API changes
                  :background_color,
                  :body,
                  :type,
                  :title_color,
                  :body_color


    # temporary fix until the API accepts JSON data in the request body
    def save
      self.client.api_post("/feed", self.create_params)
    end

    def create_params
      {
        account_id: self.client.account_id,
        type: "basic",
        url: self.url,
        params: {
          title: self.title,
          image_url: self.image_url,
          background_color: self.background_color,
          body: self.body,
          title_color: self.title_color,
          body_color: self.body_color
        }
      }
    end
  end
end
