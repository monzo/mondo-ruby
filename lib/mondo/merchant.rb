module Mondo
  class Merchant < Resource
    FIELDS = [
      :id, :group_id, :logo,
      :name, :address, :emoji,
      :raw_data
    ]

    attr_accessor    *FIELDS
    boolean_accessor :online, :is_load, :settled
    date_accessor    :created

    def address
      ::Mondo::Address.new(raw_data['address'], self.client)
    end
  end
end
