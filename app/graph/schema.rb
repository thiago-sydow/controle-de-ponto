Schema = GraphQL::Schema.define do
  query Types::QueryType

  lazy_resolve(Promise, :sync)
  instrument(:query, GraphQL::Batch::Setup)
end
