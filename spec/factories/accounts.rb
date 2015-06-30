FactoryGirl.define do
  factory :account, class: CltWorkerAccount do
    _type 'CltWorkerAccount'
    name 'Account CLT'
    active true

    factory :account_sequence do
      sequence(:name) { |n| "Account CLT #{n}" }
    end

  end

  factory :self_employed_account, class: SelfEmployedAccount do
    _type 'SelfEmployedAccount'
    name 'Freelance for Company X'
    active true
    hourly_rate 30

    factory :self_employed_account_sequence do
      sequence(:name) { |n| "Account Self Employed #{n}" }
    end

  end

end
