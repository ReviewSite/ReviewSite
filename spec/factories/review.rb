FactoryGirl.define do
  factory :review do
    junior_consultant # FactoryGirl
    review_type '6-Month'
    feedback_deadline Date.today
  end
end
