FactoryGirl.define do
  factory :associate_consultant do
    notes "This is a note about something"
    coach
    user
    reviewing_group
    graduated false
    program_start_date Date.today - 2

    factory :graduated_ac do
      graduated true
    end
  end
end
