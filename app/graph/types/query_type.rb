module Types
  QueryType = GraphQL::ObjectType.define do
    name 'Query'
    description 'The root query of this schema'

    field :currentUser, !UserType, 'The user of this request' do
      resolve -> (_obj, _args, ctx) { ctx[:current_user] }
    end
  end
end
