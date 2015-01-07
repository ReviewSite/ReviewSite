require 'spec_helper'

describe WelcomeController do

  describe "#index" do
    describe "returning user with saved OKTA name" do
      let(:user) { FactoryGirl.create :user }

      before do
        subject.current_okta_name = user.okta_name
      end

      it "should sign in the user" do
        get :index, {}, {userinfo: user.okta_name}
        controller.current_user.should == user
      end
    end

  end
end
