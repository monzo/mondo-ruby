module Mondo
  class Merchant < Resource

    attr_accessor :id, :group_id, :logo, :name, :raw_data, :address, :emoji

    date_accessor :created

    def address
      ::Mondo::Address.new(raw_data['address'], self.client)
    end

  end
end
