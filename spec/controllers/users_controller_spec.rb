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

  describe "PUT update/:id" do

    before do
      @admin = FactoryGirl.create(:admin_user) 
      @user = FactoryGirl.create(:user)
      sign_in @admin
    end

    describe "admin updates other user with valid params" do
      before(:each) do
        put :update, id: @user, user: valid_params
      end

      it "should redirect to home page" do
        response.should redirect_to root_path
      end

      it "should have a flash notice" do
        flash[:success].should_not be_blank
      end

      it "should stay logged in as admin" do
        controller.current_user.should == @admin
      end

      it "should not log in as user" do
        controller.current_user.should_not == @user
      end
    end

    describe "admin updates self" do
      it "should stay logged in as admin" do
        put :update, id: @admin, user: valid_params
        controller.current_user.should == @admin
      end
    end

    describe "normal user" do
      before do
        sign_in @user
      end

      it "cannot update another user's password" do
        @other_user = FactoryGirl.create(:user, :name => "Jane" )
        put :update, id: @other_user, user: valid_params
        response.should redirect_to root_path
        @other_user.reload
        @other_user.name.should == "Jane"
      end
    end
  end
end
