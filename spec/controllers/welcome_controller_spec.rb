require 'spec_helper'

describe WelcomeController do

  describe "#index" do
    describe "returning user" do
      let(:user) { FactoryGirl.create :user }

      before do
        subject.current_cas_name = user.cas_name
      end

      it "should sign in the user" do
        controller.should_receive(:sign_in).with(user)
        get :index
      end
    end
  end
end
