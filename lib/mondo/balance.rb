module Mondo
  class Balance < Resource
    def balance
      Money.new(raw_data['balance'], currency)
    end

    def spent_today
      Money.new(raw_data['spent_today'], currency)
    end

    def currency
      Money::Currency.new(raw_data['currency'])
    end
  end
end
