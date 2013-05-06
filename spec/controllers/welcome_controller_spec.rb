require 'spec_helper'

describe WelcomeController do

  describe "#index" do
    describe "returning user with saved CAS name" do
      let(:user) { FactoryGirl.create :user }

      before do
        subject.current_cas_name = user.cas_name
      end

      it "should sign in the user" do
        get :index
        controller.current_user.should == user
      end
    end

    describe "user without saved CAS name" do
      it "should redirect to the signin page" do
        get :index
        response.should redirect_to signin_path
      end
    end
  end
end
