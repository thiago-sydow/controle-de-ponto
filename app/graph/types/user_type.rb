module Types
  UserType = GraphQL::ObjectType.define do
    name 'User'
    description 'The account holds configuration and isolate day records'

    field :email, !types.String, 'The email of the user'
    field :firstName, !types.String, 'The name of the user', property: :first_name
    field :lastName, !types.String, 'The surname of the user', property: :last_name
    field :gender, !GenderType, 'The gender of the user'
    field :birthDay, !ISODateType, 'The birthday of the user', property: :birthday

    field :accounts, 'All accounts that this user have' do
      type Helpers::CollectionForClass.for(Account)

      argument :pageSize, types.Int, default_value: 100
      argument :page, types.Int, default_value: 1

      resolve -> (obj, args, ctx) { Loaders::AssociationLoader.for(User, :accounts, page: args[:page], page_size: args[:pageSize]).load(obj) }
    end

    field :currentAccount, !AccountType, 'The active account for the user' do
      resolve -> (obj, _args, ctx) { Loaders::RecordLoader.for(Account).load(obj.current_account_id) }
    end
  end
end
