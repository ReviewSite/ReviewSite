FactoryGirl.define do
  factory :junior_consultant do
    name 'JuniorConsultantName'
    sequence(:email) {|n| "person#{n}@example.com" }
  end
end
