FactoryGirl.define do
  factory :day_record do
    user
    reference_date Date.current
    work_day :yes
    missed_day :no
    observations 'observations test'
  end

end
