require 'spec_helper'

describe "Authentication pages" do
  subject { page }

  describe "password reset" do
    let(:user) { FactoryGirl.create(:user) }
    describe "request form" do
      before do
        visit signin_path
        click_link "Forgot password?"
      end

      it { should have_selector('title', text:'Request password reset') }

      describe "with valid information" do
        before { fill_in "Email", with: user.email }

        it "should send email when form is submitted" do
          UserMailer.should_receive(:password_reset).with(user).and_return(double("mailer", :deliver => true))
          click_button "Request password reset"
        end

        describe "directed to home page" do
          before { click_button "Request password reset" }
          it { should have_selector('h1', text:'Homepage') }
          it { should have_selector('div.alert.alert-notice') }
        end

        specify "user should still have original password" do
          click_button "Request password reset"
          visit signin_path
          fill_in "Password", with: "password"
          fill_in "Email", with: user.email
          click_button "Sign in"

          page.should_not have_selector('.alert-error')
        end
      end
    end

    describe "reset form" do
      before do
        visit new_password_reset_path
        fill_in "Email", with: user.email
        click_button "Request password reset"
        user.reload
      end

      describe "with invalid token" do
        it "should go nowhere" do
          expect{ visit edit_password_reset_path(" ") }.to raise_error
        end
      end

      describe "with expired token" do
        before do
          visit edit_password_reset_path(user.password_reset_token)
          user.update_attribute(:password_reset_sent_at, 3.hours.ago)
          fill_in "Password", with: "newpassword"
          fill_in "Password confirmation", with: "newpassword"
          click_button "Reset password"
        end

        it { should have_selector('title', text: 'Request password reset') }
        it { should have_selector('.alert') }

        specify "old password should still work" do
          visit signin_path
          fill_in "Email", with: user.email
          fill_in "Password", with: "password"
          click_button "Sign in"
          page.should_not have_selector('.alert-error')
        end

        specify "new password should not work" do
          visit signin_path
          fill_in "Email", with: user.email
          fill_in "Password", with: "newpassword"
          click_button "Sign in"
          page.should have_selector('.alert-error')
        end
      end

      describe "with valid token" do
        before { visit edit_password_reset_path(user.password_reset_token) }
        it { should have_selector('title', text: 'Reset password') }
        it { should_not have_selector('.alert-error') }

        it "gives error messages if password validations fail" do
          click_button "Reset password"
          page.should have_selector('.error-messages')
        end

        describe "successful reset" do
          before do
            fill_in "Password", with: "newpassword"
            fill_in "Password confirmation", with: "newpassword"
            click_button "Reset password"
          end

          it { should have_selector('h1', text: 'Homepage') }
          it { should have_selector('.alert-notice') }

          specify "old password should not work" do
            visit signin_path
            fill_in "Email", with: user.email
            fill_in "Password", with: "password"
            click_button "Sign in"
            page.should have_selector('.alert-error')
          end

          specify "new password should work" do
            visit signin_path
            fill_in "Email", with: user.email
            fill_in "Password", with: "newpassword"
            click_button "Sign in"
            page.should_not have_selector('.alert-error')
          end
        end
      end
    end
  end
end