FactoryBot.define do
  factory :day_record do
    account
    reference_date { Date.current }
    work_day { :yes }
    missed_day { :no }
    medical_certificate { :no }
    observations { 'observations test' }

    factory :day_record_sequence do
      sequence(:reference_date) { |n| Date.current - n.days }
    end

    factory :day_record_with_times do
      transient do
        times_count { 3 }
      end

      after(:create) do |day, evaluator|
        create_list(:time_record, evaluator.times_count, day_record: day)
      end
    end
  end
end
