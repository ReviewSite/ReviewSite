require "spec_helper"

describe SessionsController do

  describe "#callback" do

    describe "when the user doesn't exist yet" do
      let(:unpersisted_user_email) { "twer@example.com" }
      let(:unpersisted_user_name) { "ThoughtWorker" }

      before(:all) do
        OmniAuth.config.add_mock(:saml, { uid: unpersisted_user_email, info: { name: unpersisted_user_name } })
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:saml]
      end

      it "should create a new user" do
        expect {
          post :callback, { provider: :saml }
        }.to change(User, :count).by(1)
      end

      it "new user should have valid credentials set" do
        post :callback, { provider: :saml }

        new_user = User.last
        new_user.admin.should be false
        new_user.name.should eq unpersisted_user_name
        new_user.okta_name.should eq "twer"
        new_user.email.should eq unpersisted_user_email
      end
    end

    describe "when the user already exists" do
      let(:persisted_user) { create(:user) }

      before(:all) do
        OmniAuth.config.add_mock(:saml, { uid: persisted_user.email })
        Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:saml]
      end

      it "should find the user" do
        expect {
          post :callback, { provider: :saml }
        }.to change(User, :count).by(0)
      end
    end
  end
end
