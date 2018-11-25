FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }

    password { 'password' }
    password_confirmation { 'password' }
    first_name { 'Thiago' }
    last_name { 'von Sydow' }
    gender { :male }
    birthday { Date.parse('27/07/1990') }
  end
end
