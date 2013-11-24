FactoryGirl.define do
  factory :review do
    junior_consultant # FactoryGirl
    review_type '6-Month'
    feedback_deadline Date.today
    new_review_format false
  end
end
