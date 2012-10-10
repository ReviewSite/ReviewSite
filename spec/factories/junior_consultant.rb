FactoryGirl.define do
  factory :junior_consultant do
    sequence(:name) {|n| "JuniorConsultantName#{n}" }
    sequence(:email) {|n| "person#{n}@example.com" }
    notes "This is a note about something"
  end
end
