FactoryGirl.define do
  factory :user do
    name 'Robin'
    sequence(:email) {|n| "person#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
    admin false
    factory :admin_user do
      admin true
    end
  end
end
