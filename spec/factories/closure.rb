FactoryGirl.define do
  factory :closure do
    user
    start_date Date.current - 3.months
    end_date Date.current
  end

end
