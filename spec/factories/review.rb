FactoryGirl.define do
  factory :review do
    associate_consultant
    review_type { %w(6-Month 12-Month 18-Month 24-Month).sample }
    feedback_deadline Date.today.next_month
    review_date Date.today.next_month.next_day(2)
    new_review_format false

    factory :new_review_type do
      new_review_format true
    end
  end
end
