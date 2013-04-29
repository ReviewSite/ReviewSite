FactoryGirl.define do
  factory :user, :aliases => [:coach] do
    name 'Robin'
    cas_name 'robincas'
    sequence(:email) {|n| "person#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
    admin false
    factory :admin_user do
      admin true
    end
  end
end
