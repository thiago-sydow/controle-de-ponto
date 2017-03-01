module Types
  GenderType = GraphQL::EnumType.define do
    name 'Gender'
    description 'Gender definition enumerable'

    value 'MALE', value: 'male'
    value 'FEMALE', value: 'female'
  end
end
