FactoryGirl.define do
  factory :user, :aliases => [:coach] do
    name 'Robin'
    sequence(:cas_name) { |n| "person#{n}" }
    sequence(:email) {|n| "person#{n}@example.com" }
    admin false
    factory :admin_user do
      admin true
    end
  end
end
