module Mondo
  class Merchant < Resource

    attr_accessor :id, :group_id, :logo, :name, :raw_data, :address, :emoji

    boolean_accessor :online, :is_load, :settled

    date_accessor :created

    def address
      ::Mondo::Address.new(raw_data['address'], self.client)
    end

  end
end
