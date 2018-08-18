module Mondo
  class Pot < Resource

    attr_accessor :id,
      :name,
      :style,
      :balance,
      :currency,
      :type,
      :minimum_balance,
      :maximum_balance,
      :round_up

      date_accessor :created
      date_accessor :updated
      date_accessor :deleted

    def balance
      Money.new(raw_data['balance'], currency)
    end

    def currency
      Money::Currency.new(raw_data['currency'])
    end
  end
end
