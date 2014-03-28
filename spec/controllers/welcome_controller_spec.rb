require 'spec_helper'

describe WelcomeController do

  describe "#index" do
    describe "returning user with saved CAS name" do
      let(:user) { FactoryGirl.create :user }

      before do
        subject.current_cas_name = user.cas_name
      end

      it "should sign in the user" do
        get :index, {}, {userinfo: user.cas_name}
        controller.current_user.should == user
      end
    end

    describe "user without saved CAS name" do
      it "should redirect to the signup page" do
        get :index, {}, {userinfo: "test@test.com"}
        response.should redirect_to signup_path
      end
    end
  end
end
