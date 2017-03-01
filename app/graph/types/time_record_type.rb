module Types
  TimeRecordType = GraphQL::ObjectType.define do
    name 'TimeRecord'
    description 'Record for a da times'

    field :time, !ISODateTimeType, 'Time of this record'
  end
end
