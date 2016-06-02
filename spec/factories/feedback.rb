FactoryGirl.define do
  factory :feedback do
    review
    user
    user_string nil
    project_worked_on "Death Star II"
    role_description "Independent Contractor"
    role_competence_to_be_improved "Don't get blown up with the Death Star"
    submitted false

    factory :submitted_feedback do
      submitted true
    end

    factory :external_feedback do
      user_string "Not nil"
    end
  end
end
