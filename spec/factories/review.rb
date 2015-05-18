FactoryGirl.define do
  factory :review do
    associate_consultant
    review_type { %w(6-Month 12-Month 18-Month 24-Month).sample }
    feedback_deadline 1.day.from_now
    review_date 1.month.from_now
    new_review_format false

    factory :new_review_type do
      new_review_format true
    end

    factory :twenty_four_month_review do
      review_type '24-Month'
      review_date 1.day.ago
      feedback_deadline 2.days.ago
    end
  end
end
