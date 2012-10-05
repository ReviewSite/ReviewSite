FactoryGirl.define do
  factory :user do
    name 'Robin'
    email 'rdunlop@thoughtworks.com'
    password 'password'
    password_confirmation 'password'
    admin false
  end
end
