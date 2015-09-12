module Mondo
	class Transaction

    attr_accessor :id, 
                  :created,
                  :description,
                  :amount,
                  :currency,
                  :merchant,
                  :notes,
                  :metadata,
                  :raw_data

		def initialize(hash={})
      self.raw_data = hash
			hash.each { |key,val| send("#{key}=", val) if respond_to?("#{key}=") }
      self.to_s
		end

    def to_s
      "#<#{self.class} #{self.amount_with_currency} #{self.description} #{id}>"
    end

    def inspect
      self.to_s
    end

    # TODO - proper currency library
    def amount_with_currency
      "#{amount/100}#{currency}"
    end
	end
end