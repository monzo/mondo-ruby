module Mondo
  class Transaction < Resource

    attr_accessor :id,
      :description,
      :amount,
      :currency,
      :notes,
      :metadata

    date_accessor :created

    # TODO - proper currency library
    def amount_with_currency
      "#{amount/100}#{currency}"
    end

    def save_metadata
      self.client.api_patch("/transactions/#{self.id}", metadata: self.metadata)
    end

    def register_attachment(args={})
      attachment = Attachment.new(
        {
          external_id: self.id,
          file_url: args.fetch(:file_url),
          file_type: args.fetch(:file_type)
        },
        self.client
      )

      self.attachments << attachment if attachment.register
    end

    def attachments
      @transactions ||= begin
        raw_data['attachments'].map { |tx| Attachment.new(tx, self.client) }
      end
    end

    def merchant(opts={})
      unless raw_data['merchant'].kind_of?(Hash)
        # Go and refetch the transaction with merchant info expanded
        self.raw_data['merchant'] = self.client.transaction(self.id, expand: [:merchant]).raw_data['merchant']
      end

      ::Mondo::Merchant.new(raw_data['merchant'], client) unless raw_data['merchant'].nil?
    end

    def tags
      metadata["tags"]
    end

    def tags=(t)
      metadata["tags"] = t
    end
  end
end
