module Mondo
  class Account < Resource

    attr_accessor :id, :description, :raw_data, :sort_code, :account_number

    date_accessor :created
  end
end
