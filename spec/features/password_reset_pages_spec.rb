require 'spec_helper'

describe "Password reset pages" do
  subject { page }

  let(:user) { FactoryGirl.create(:user, password_digest: BCrypt::Password.create("password")) }

  describe "Request password reset" do
    describe "request form" do
      before do
        visit signin_path
        click_link "Forgot password?"
      end

      describe "with invalid information" do
        before { click_button "Request password reset" }

        it { should have_selector('h1', text:'Sign in') }
        it { should have_selector('div.alert.alert-notice') }
      end

      describe "with valid information" do
        before { fill_in "Email", with: user.email }

        it "should send email when form is submitted" do
          UserMailer.should_receive(:password_reset).with(user).and_return(double("mailer", :deliver => true))
          click_button "Request password reset"
        end

        describe "directed to signin page" do
          before { click_button "Request password reset" }
          it { should have_selector('h1', text:'Sign in') }
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

    describe "Create new password" do
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
          user.update_attribute(:password_reset_sent_at, 3.hours.ago)
          visit edit_password_reset_path(user.password_reset_token)
        end

        it "should redirect to the new password reset form" do
          page.should have_selector('.alert')
          current_path.should == new_password_reset_path
        end
      end

      describe "with valid token" do
        before do
          visit edit_password_reset_path(user.password_reset_token)
        end

        it "should sign user is and redirect to homepage" do
          current_path.should == root_path
          user.reload
          user.cas_name.should == "homer"
        end
      end
    end
  end
end