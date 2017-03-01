module Types
  AccountType = GraphQL::ObjectType.define do
    name 'Account'
    description 'The account holds configuration and day records'

    field :type, !AccountTypeType, 'The type of account'
    field :name, !types.String, 'The name of the account'
    field :workload, !types.Int, 'The workload configured (in seconds)'

    field :dayRecords, 'Day records present in the account' do
      type Helpers::CollectionForClass.for(DayRecord)

      argument :pageSize, types.Int, default_value: 100
      argument :page, types.Int, default_value: 1

      resolve -> (obj, args, ctx) { Loaders::AssociationLoader.for(Account, :day_records, page: args[:page], page_size: args[:pageSize]).load(obj) }
    end
  end
end
