FactoryGirl.define do
  factory :self_assessment do
    associate_consultant
    review
    response "These are some notes that I have written"
  end
end
