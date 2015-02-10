FactoryGirl.define do
  factory :record do
    time Time.current
    user
  end

end
