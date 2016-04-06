module Mondo
  class Address < Resource
    FIELDS = [
      :address, :city, :region,
      :country, :postcode,
      :latitude, :longitude,
      :short_formatted, :formatted
    ]

    attr_accessor *FIELDS
  end
end
