module Mondo
  class Account < Resource
    FIELDS = [
      :id, :account_number,
      :description, :sort_code
    ]

    attr_accessor *FIELDS
    date_accessor :created

    def balance
      self.client.balance(@id)
    end
  end
end
