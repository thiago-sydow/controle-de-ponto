FactoryBot.define do
  factory :account, class: CltWorkerAccount do
    type { 'CltWorkerAccount' }
    sequence(:name) { |n| "Account CLT #{n}" }
    warn_straight_hours { true }
    warn_overtime { true }
    warn_rest_period { true }
    allowance_time { 0 }
    user
  end

  factory :self_employed_account, class: SelfEmployedAccount do
    type { 'SelfEmployedAccount' }
    sequence(:name) { |n| "Account Self Employed #{n}" }
    hourly_rate { 30 }
    user
  end

  factory :student_account, class: StudentAccount do
    type { 'StudentAccount' }
    sequence(:name) { |n| "Studies Control Account #{n}" }
    workload { 14400 }
    user
  end

end
