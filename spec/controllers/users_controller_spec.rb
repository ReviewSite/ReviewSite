require 'spec_helper'

describe UsersController do
  def valid_params
    {
        name: 'Joe',
        email: 'joe@example.com',
        password: 'password',
        password_confirmation: 'password'
    }
  end
  describe "#create" do
    let(:current_user) { User.new }
    context 'A user is already logged in' do

      before do
        controller.current_user = current_user
        User.any_instance.stub(:save).and_return(true)
      end

      it 'should not sign in the newly created user' do
        controller.should_not_receive(:sign_in)
        post :create, {user: valid_params}
      end

      it 'should set the flash message' do
        post :create, {user: valid_params}
        flash[:success].should_not be_nil
      end

      it 'should redirect to the users page' do
        post :create, {user: valid_params}
        response.should redirect_to root_path
      end

    end

    context "Admin registers a user" do
      before do
        admin = FactoryGirl.create(:admin_user)
        sign_in admin
      end
      it 'should send an admin email' do
        UserMailer.any_instance.should_receive(:admin_registration_confirmation)
        post :create, {user: valid_params}
        ActionMailer::Base.deliveries.last.to.should == [valid_params[:email]]
      end
    end

    context "Users registers him/hersef" do
      it 'should send an admin email' do
        UserMailer.any_instance.should_receive(:self_registration_confirmation)
        post :create, {user: valid_params}
        ActionMailer::Base.deliveries.last.to.should == [valid_params[:email]]
      end
    end
  end
end
