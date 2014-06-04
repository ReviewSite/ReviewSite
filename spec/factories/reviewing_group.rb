FactoryGirl.define do
  factory :reviewing_group do
    name "Central"

    factory :reviewing_group_with_users do
      users {[FactoryGirl.create(:user)]}
    end

  end

end
