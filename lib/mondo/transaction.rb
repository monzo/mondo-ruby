module Mondo
  class Transaction < Resource

    attr_accessor :id, 
      :description,
      :amount,
      :currency,
      :merchant,
      :notes,
      :metadata,
      :raw_data

    date_accessor :created

    def to_s
      "#<#{self.class} #{self.amount_with_currency} #{self.description} #{id}>"
    end

    def inspect
      self.to_s
    end

    # TODO - proper currency library
    def amount_with_currency
      "#{amount/100}#{currency}"
    end

    def save_metadata
      self.client.api_patch("/transactions/#{self.id}", metadata: self.metadata)
    end

    def tags
      metadata["tags"]
    end

    def tags=(t)
      metadata["tags"] = t
    end
  end
end
