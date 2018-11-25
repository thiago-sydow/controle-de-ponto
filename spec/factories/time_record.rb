FactoryBot.define do
  factory :time_record do
    day_record
    time { Faker::Time.between(Time.current.midnight, Time.current.change(hour: 23, minute: 59)) }
  end

end
