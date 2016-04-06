module Mondo
  class FeedItem < Resource
    FIELDS = [
      :title, :image_url, :url, # TODO - make "url" consistent when the Mondo API changes
      :background_color, :body, :type
    ]

    # temporary fix until the API accepts JSON data in the request body
    def save
      self.client.api_post("/feed", self.create_params)
    end

    private

    def create_params
      {
        type:       "basic",
        account_id: self.client.account_id,
        url:        self.url,
        params: {
          title:            self.title,
          image_url:        self.image_url,
          background_color: self.background_color,
          body:             self.body
        }
      }
    end
  end
end