module ActiveRecord
  module Enum
    class EnumType < Type::Value
      def assert_valid_value(value)
        # override assert_valid_value() to supress <ArgumentError>
        # return a value and depend on our own validation
        value
      end
    end
  end
end
