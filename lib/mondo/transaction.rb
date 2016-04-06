module Mondo
  class Transaction < Resource

    FIELDS = [
      :id, :description, :notes,
      :metadata, :is_load, :category,
      :settled, :decline_reason
    ]

    attr_accessor *FIELDS

    date_accessor :created, :settled

    def declined?
      raw_data['decline_reason'].present?
    end

    def amount
      Money.new(raw_data['amount'], currency)
    end

    def local_amount
      Money.new(raw_data['local_amount'], local_currency)
    end

    def account_balance
      Money.new(raw_data['account_balance'], currency)
    end

    def currency
      Money::Currency.new(raw_data['currency'])
    end

    def local_currency
      Money::Currency.new(raw_data['local_currency'])
    end

    def save_metadata
      self.client.api_patch("/transactions/%i" % self.id, metadata: self.metadata)
    end

    def register_attachment(args={})
      attachment = Attachment.new({
        external_id: self.id,
        file_url:    args.fetch(:file_url),
        file_type:   args.fetch(:file_type)
      }, self.client)

      self.attachments << attachment if attachment.register
    end

    def attachments
      @transactions ||= begin
        raw_data['attachments'].map do |attachment|
          Attachment.new(attachment, self.client)
        end
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
