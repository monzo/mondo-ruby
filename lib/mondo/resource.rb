module Mondo
  class Resource

    attr_accessor :client, :raw_data

    def initialize(hash = {}, client)
      self.raw_data = hash
      self.client = client

      hash.each do |key, val|
        if respond_to?("#{key}=")
          send("#{key}=", val)
        end
      end
    end

    def to_s
      "#<#{self.class} #{raw_data}>"
    end

    def inspect
      to_s
    end

    class << self
      def date_writer(*args)
        args.each do |attr|
          define_method("#{attr.to_s}=".to_sym) do |date|
            date = (date.is_a?(String) ? DateTime.parse(date) : date) rescue date
            instance_variable_set("@#{attr}", date)
          end
        end
      end

      def date_accessor(*args)
        attr_reader(*args)
        date_writer(*args)
      end

      def boolean_accessor(*attrs)
        attr_accessor(*attrs)
        alias_question(attrs)
      end

      def boolean_reader(*attrs)
        attr_reader(*attrs)
        alias_question(attrs)
      end

      private

      def alias_question(attrs)
        attrs.each do |attr|
          define_method("#{attr}?") do
            send(attr) || false
          end
        end
      end
    end
  end
end
