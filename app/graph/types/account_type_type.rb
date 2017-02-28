module Types
  AccountTypeType = GraphQL::EnumType.define do
    name 'AccountType'
    description 'Type of account enumerable'

    value 'CLT', 'CLT account provides specific calculations for Brazilian CLT rules', value: 'CltWorkerAccount'
    value 'SELF_EMPLOYED', value: 'SelfEmployedAccount'
    value 'STUDENT', value: 'StudentAccount'
  end
end
