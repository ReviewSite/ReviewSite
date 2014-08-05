FactoryGirl.define do
  factory :self_assessment do
    associate_consultant # FactoryGirl
    review # FactoryGirl
    response 'These are some notes that I have written'
  end
end
