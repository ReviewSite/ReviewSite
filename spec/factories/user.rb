FactoryGirl.define do
  factory :user do
    name 'Robin'
    sequence(:email) {|n| "person#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
    admin false
  end
end
