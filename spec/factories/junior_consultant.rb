FactoryGirl.define do
  factory :junior_consultant do
    name 'Robin'
    sequence(:email) {|n| "person#{n}@example.com" }
  end
end
