module Mondo
  class Resource

    attr_accessor :client

    def initialize(hash={}, client)
      self.raw_data = hash
      self.client = client
      hash.each { |key,val| send("#{key}=", val) if respond_to?("#{key}=") }
      self.to_s
    end

    class << self
      def date_writer(*args)
        args.each do |attr|
          define_method("#{attr.to_s}=".to_sym) do |date|
            date = date.is_a?(String) ? DateTime.parse(date) : date
            instance_variable_set("@#{attr}", date)
          end
        end
      end

      def date_accessor(*args)
        attr_reader *args
        date_writer *args
      end
    end
  end
end
