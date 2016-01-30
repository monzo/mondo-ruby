module Mondo
  class Card < Resource
    attr_accessor :id, :processor_token, :processor, :account_id,
                :last_digits, :name, :expires, :status

    date_accessor :created

    def active?
      status == 'ACTIVE'
    end

    def freeze!
      self.client.api_put("/card/toggle", {
        card_id: id,
        status: 'INACTIVE'
      })
    end

    def unfreeze!
      self.client.api_put("/card/toggle", {
        card_id: id,
        status: 'ACTIVE'
      })
    end
  end
end
