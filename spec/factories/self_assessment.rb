FactoryGirl.define do
  factory :self_assessment do
    associate_consultant
    review
    response "These are some notes that I have written"
    learning_assessment "These are some learning notes that I've written"
  end
end
