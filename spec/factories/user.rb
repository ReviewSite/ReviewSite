FactoryGirl.define do
  factory :user, :aliases => [:coach] do
    sequence(:name) { |n| "User Named # #{n}" }
    sequence(:okta_name) { |n| "person#{n}" }
    sequence(:email) {|n| "person#{n}@thoughtworks.com" }
    admin false

    factory :admin_user, aliases: [:admin] do
      admin true
      sequence(:name) { |n| "Admin # #{n}" }
    end
  end
end
