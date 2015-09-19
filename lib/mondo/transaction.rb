module Mondo
  class Transaction < Resource

    attr_accessor :id,
      :description,
      :amount,
      :currency,
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

    def merchant(opts={})
      if raw_data['merchant'].kind_of?(Hash)
        ::Mondo::Merchant.new(raw_data['merchant'], client)
      else
        self.raw_data['merchant'] = self.client.transaction(self.id, expand: [:merchant]).raw_data['merchant']
        merchant(opts)
      end
    end

    def tags
      metadata["tags"]
    end

    def tags=(t)
      metadata["tags"] = t
    end
  end
end
