module Mondo
  class Balance < Resource
    def balance
      as_money(raw_data['balance'])
    end

    def spent_today
      as_money(raw_data['spent_today'])
    end

    def currency
      Money::Currency.new(raw_data['currency'])
    end

    private

    def as_money(data)
      Money.new(data, currency)
    end
  end
end
