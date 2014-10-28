require 'spec_helper'

describe "PasswordReset" do
  subject { page }

  let(:user) { FactoryGirl.create(:user,
    password_digest: BCrypt::Password.create("password")) }

  before do
    visit root_path

    within "#okta-input" do
      fill_in "temp-okta", with: "askjdh"
      click_button "Change User"
    end

    click_button "Change User"
    visit signin_path
    click_link "Forgot password?"
  end

  describe "GET /password_resets/new" do
    it "has the correct title" do
      title.should == "Review Site | Request Password Reset"
    end
  end

  describe "requesting a new password" do
    context "with invalid information" do
      before { click_button "Request Password Reset" }

      describe "should redirect to the sign in page" do
          it { should have_selector('h1', text:'Reset Password') }
      end

      describe "should display a flash notice" do
        it { should have_selector('.flash-alert'),
          text: "Please include an email address." }
      end
    end

    context "with valid information" do
      before do
        fill_in "Email", with: user.email
      end

      it "should send email when form is submitted" do
        UserMailer.should_receive(:password_reset).with(user).and_return(double("mailer", :deliver => true))
        click_button "Request Password Reset"
      end

      it "should redirect to Sign In page" do
        click_button "Request Password Reset"
        page.should have_selector('h1', text:'Sign In')
      end

      it "should display a flash notice" do
        click_button "Request Password Reset"
        page.should have_selector('.flash-notice')
      end
    end

    context "when the user signs in" do
      before do
        fill_in "Email", with: user.email
        click_button "Request Password Reset"
      end

      it "they should still have original password" do
        fill_in "Password", with: "password"
        fill_in "Email", with: user.email
        click_button "Sign In"

        page.should_not have_selector('.flash-error')
      end
    end
  end

  describe "create a new password" do
    before do
      visit new_password_reset_path
      fill_in "Email", with: user.email
      click_button "Request Password Reset"
      user.reload
    end

    context "with invalid token" do
      it "should go nowhere" do
        expect{ visit edit_password_reset_path(" ") }.to raise_error
      end
    end

    context "with expired token" do
      before do
        user.update_attribute(:password_reset_sent_at, 3.hours.ago)
        visit edit_password_reset_path(user.password_reset_token)
      end

      it "should redirect to the new password reset form" do
        page.should have_selector('.flash')
        current_path.should == new_password_reset_path
      end
    end

    context "with valid token" do
      before do
        visit edit_password_reset_path(user.password_reset_token)
      end

      it "should sign user in and redirect to homepage" do
        expected_okta_name = user.okta_name
        current_path.should == root_path
        user.reload
        user.okta_name == expected_okta_name
      end
    end
  end
end
