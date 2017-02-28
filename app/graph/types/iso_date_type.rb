module Types
  # An ISO-8601 formatted date string.
  ISODateType = GraphQL::ScalarType.define do
    name 'ISODate'
    description 'An ISO8601 formatted date'

    coerce_result -> (value) { value.to_date.iso8601 }

    # Will attempt to parse the input as an ISO-8601 formatted string.
    # DateTime.iso8601 raises an ArgumentError if it's passed an invalid
    # string, and a TypeError if somehow given something else (like an int).
    coerce_input -> (value) {
      begin
        Date.iso8601(value)
      rescue ArgumentError, TypeError
        nil
      end
    }
  end
end
