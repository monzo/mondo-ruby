module Mondo
  class Account < Resource

    attr_accessor :id, :description, :raw_data

    date_accessor :created
  end
end
