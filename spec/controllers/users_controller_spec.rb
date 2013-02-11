require 'spec_helper'

describe UsersController do
  describe "#create" do
    context 'A user is already logged in' do
      let(:current_user) { User.new }
      let(:params) { {name: 'Joe', email: 'joe@example.com', 
                    password: 'pass', password_confirmation: 'pass' } }

      before do
        controller.current_user = current_user
        User.any_instance.stub(:save).and_return(true)
      end

      it 'should not sign in the newly created user' do
        controller.should_not_receive(:sign_in)
        post :create, params
      end

      it 'should set the flash message' do
        post :create, params
        flash[:success].should_not be_nil
      end

      it 'should redirect to the users page' do
        post:create, params
        response.should redirect_to(:users)
      end
    end
  end
end
