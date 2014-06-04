FactoryGirl.define do
  factory :user, :aliases => [:coach] do
    sequence(:name) { |n| "User Named # #{n}" }
    sequence(:okta_name) { |n| "person#{n}" }
    sequence(:email) {|n| "person#{n}@example.com" }
    admin false

    factory :admin_user do
      admin true
      sequence(:name) { |n| "Admin # #{n}" }
    end

  end
end
