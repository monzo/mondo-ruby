module Mondo
  class Card < Resource
    FIELDS = [
      :id, :account_id, :status,
      :name, :last_digits, :expires,
      :processor_token, :processor
    ]

    attr_accessor *FIELDS
    date_accessor :created

    def active?
      status == 'ACTIVE'
    end

    def freeze
      set_freeze_state(:inactive)
    end

    def unfreeze
      set_freeze_state(:inactive)
    end

    private

    def set_freeze_state(state)
      case state
      when :active
        state = 'ACTIVE'
      when :inactive
        state = 'INACTIVE'
      else
        raise ClientError.new("You must provide an valid freeze state (:active || :inactive)")
      end

      client.api_put("/card/toggle", { card_id: id, status: state })
    end
  end
end
