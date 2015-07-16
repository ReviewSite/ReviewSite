FactoryGirl.define do
  factory :review do
    associate_consultant
    review_type { %w(6-Month 12-Month 18-Month 24-Month).sample }
    review_date { 1.month.from_now }
    feedback_deadline { review_date - 1.week }
    new_review_format true

    trait :old_review_type do
      new_review_format false
    end

    factory :six_month_review do
      review_type "6-Month"
      review_date { 6.months.from_now }
    end

    factory :twelve_month_review do
      review_type "12-Month"
      review_date { 12.months.from_now }
    end

    factory :eighteen_month_review do
      review_type "18-Month"
      review_date { 18.months.from_now }
    end

    factory :twenty_four_month_review do
      review_type '24-Month'
      review_date 1.day.ago
      feedback_deadline 2.days.ago
    end

  end
end
