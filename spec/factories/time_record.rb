FactoryGirl.define do
  factory :time_record do
    day_record
    time Time.current
  end

end
