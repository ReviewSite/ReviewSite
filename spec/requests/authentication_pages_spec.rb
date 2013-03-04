require 'spec_helper'

describe "Authentication pages" do
  subject { page }

  describe "password reset" do
    describe "request form" do
      before do
        visit signin_path
        click_link "Forgot password"
      end

      it { should have_selector('title', text:'Reset password') }

      describe "with valid information" do
        let(:user) { FactoryGirl.create(:user) }
        before { fill_in "Email", with: user.email }

        it "should send email when form is submitted" do
          UserMailer.should_receive(:password_reset).with(user)
          click_button "Reset password"
        end

        describe "directed to home page" do
          before { click_button "Reset password" }
          it { should have_selector('h1', text:'Homepage') }
          it { should have_selector('div.alert.alert-notice') }
        end

        specify "user should still have original password" do
          click_button "Reset password"
          visit signin_path
          fill_in "Password", with: "password"
          fill_in "Email", with: user.email
          click_button "Sign in"

          page.should_not have_selector('.alert-error')
        end
      end
    end
  end
end