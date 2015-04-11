FactoryGirl.define do
  factory :time_record do
    day_record
    time { Faker::Time.between(Time.current.yesterday, Time.current) }
  end

end
