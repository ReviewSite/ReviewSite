include ApplicationHelper

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    page.should have_selector('div.alert.alert-error', text: 'Invalid')
  end
end

def set_current_user(user)
  session[:temp_cas_user] = user.cas_name
  controller.reset_current_user
end

def sign_in(user)
  visit root_path
  within "#cas-input" do
    fill_in "temp-cas", with: user.cas_name
    click_button "Set CAS"
  end
end