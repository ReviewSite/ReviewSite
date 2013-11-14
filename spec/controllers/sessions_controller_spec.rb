require 'spec_helper'

describe SessionsController do
  describe "#new" do

    context "A user is logged in" do
      before do
        user = FactoryGirl.create(:user)
        set_current_user user
      end

      it "should redirect to home page" do
        get :new
        response.should redirect_to(root_url)
      end
    end

  end
end