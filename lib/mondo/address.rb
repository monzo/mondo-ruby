module Mondo
  class Address < Resource
    attr_accessor :address, :city, :region, :country, :postcode, :latitude,
      :longitude, :raw_data, :short_formatted, :formatted
  end
end
