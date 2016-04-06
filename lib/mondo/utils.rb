require 'uri'

module Mondo
  module Utils
    extend self

    # String Helpers
    module String
      def camelize(string)
        string.split('_').map(&:capitalize).join
      end

      def underscore(string)
        string.gsub(/(.)([A-Z])/) { "#{$1}_#{$2.downcase}" }.downcase
      end
    end

    # Hash Helpers
    module Hash
      def symbolize_keys(hash)
        symbolize_keys!(hash.dup)
      end

      def symbolize_keys!(hash)
        hash.keys.each do |key|
          sym_key = key.to_s.to_sym rescue key
          hash[sym_key] = hash.delete(key) unless hash.key?(sym_key)
        end

        hash
      end
    end
  end
end
