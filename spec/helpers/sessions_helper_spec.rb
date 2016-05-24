require "spec_helper"

class Klass
  include SessionsHelper
end

describe SessionsHelper do
  let(:klass) { Klass.new }
  let(:email) { "twer@example.com" }

  describe "#current_name" do
    let(:name) { "Funky Claude" }
    let(:okta_name) { "twer" }

    it "should use the okta name when a real name isn't available" do
      session[:userinfo] = email
      session[:user_name] = nil

      klass.real_name_or_default.should eq "twer"
    end

    it "should give the real name of the user when available" do
      session[:userinfo] = email
      session[:user_name] = name

      klass.real_name_or_default.should eq "Funky Claude"
    end

  end

  describe "#current_okta_name" do
    it "splits the email in prod environments" do
      session[:temp_okta_user] = nil
      session[:userinfo] = email

      klass.current_okta_name.should eq "twer"
    end

    it "gets the temp okta name in test environments" do
      session[:temp_okta_user] = "foo"
      session[:userinfo] = email

      klass.current_okta_name.should eq "foo"
    end
  end
end
