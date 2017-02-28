module Types
  # An ISO-8601 formatted date with time string.
  ISODateTimeType = GraphQL::ScalarType.define do
    name 'ISODateTime'
    description 'An ISO8601 formatted date with time'

    coerce_result -> (value) { value.iso8601 }

    # Will attempt to parse the input as an ISO-8601 formatted string.
    # DateTime.iso8601 raises an ArgumentError if it's passed an invalid
    # string, and a TypeError if somehow given something else (like an int).
    coerce_input -> (value) {
      begin
        DateTime.iso8601(value)
      rescue ArgumentError, TypeError
        nil
      end
    }
  end
end
