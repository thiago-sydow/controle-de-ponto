FactoryGirl.define do
  factory :user do
    email 'thiagovs05@gmail.com'
    password 'password'
    password_confirmation 'password'
    name 'Thiago'
    birthday Date.today
    job 'Ruby Developer'
  end

end
