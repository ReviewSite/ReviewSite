FactoryGirl.define do
  factory :associate_consultant do
    notes "This is a note about something"
    coach
    user
    reviewing_group
    graduated false
    program_start_date Date.today

    trait :has_graduated do
      program_start_date Date.today - 1 - 24.months
      graduated true
    end
  end
end
