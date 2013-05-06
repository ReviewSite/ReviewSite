include ApplicationHelper

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: 'Invalid')
  end
end

def set_current_user(user)
  controller.current_user = user
end

def sign_in(user)
  visit signin_path
  fill_in "Email",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def set_cas_user(username)
  visit root_path
  within "#cas-input" do
    fill_in "temp-cas", with: username
    click_button "Set CAS"
  end
end