FactoryGirl.define do
    factory :feedback do
        review
        user
        user_string nil
        submitted false
        factory :submitted_feedback do
          submitted true
        end
    end
end

