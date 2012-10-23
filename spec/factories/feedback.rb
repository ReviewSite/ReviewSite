FactoryGirl.define do
    factory :feedback do
        review # FactoryGirl
        user # FactoryGirl
        submitted false
        factory :submitted_feedback do
          submitted true
        end
    end
end

