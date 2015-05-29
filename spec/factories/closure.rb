FactoryGirl.define do
  factory :closure do
    account
    start_date Date.current - 3.months
    end_date Date.current
  end

end
