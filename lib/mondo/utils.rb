require 'uri'

module Mondo
  module Utils
    extend self

    # String Helpers
    def camelize(str)
      str.split('_').map(&:capitalize).join
    end

    def underscore(str)
      str.gsub(/(.)([A-Z])/) { "#{$1}_#{$2.downcase}" }.downcase
    end
  end
end
