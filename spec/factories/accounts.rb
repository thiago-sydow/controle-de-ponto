FactoryGirl.define do
  factory :account, class: CltWorkerAccount do
    name 'Account CLT'
    active true

    factory :account_sequence do
      sequence(:name) { |n| "Account CLT #{n}" }
    end

  end

end
