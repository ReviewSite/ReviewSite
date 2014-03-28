require 'spec_helper'

describe UsersController do
  def valid_params
    {
        name: 'Joe',
        email: 'joe@example.com',
        cas_name: 'JoeCAS'
    }
  end

  def valid_session
    {
        userinfo: "test@test.com"
    }
  end

  describe "#create" do
    context "Normal user registers another user" do
      before do
        user = FactoryGirl.create(:user)
        set_current_user user
      end

      it "should be forbidden" do
        post :create, {user: valid_params}, valid_session
        response.should redirect_to root_path
      end
    end

    context "Admin registers a user" do
      before do
        admin = FactoryGirl.create(:admin_user)
        set_current_user admin
      end

      it 'should not sign in the newly created user' do
        controller.should_not_receive(:set_current_user)
        post :create, {user: valid_params}, valid_session
      end

      it 'should set the flash message' do
        post :create, {user: valid_params}, valid_session
        flash[:success].should_not be_nil
      end

      it 'should redirect to the root path' do
        post :create, {user: valid_params}, valid_session
        response.should redirect_to root_path
      end

      it 'should send an admin email' do
        UserMailer.any_instance.should_receive(:registration_confirmation)
        post :create, {user: valid_params}, valid_session
        ActionMailer::Base.deliveries.last.to.should == [valid_params[:email]]
      end
    end

    context "Users registers him/herself" do
      it 'should send an admin email' do
        UserMailer.any_instance.should_receive(:registration_confirmation)
        post :create, {user: valid_params}, valid_session
        ActionMailer::Base.deliveries.last.to.should == [valid_params[:email]]
      end

      it 'should set the cas_name to the already authenticated cas name' do
        controller.current_cas_name = "testCAS"
        post :create, {user: {name: "Test", email: "test@example.com", cas_name: "testCAS"}}, valid_session
        user = assigns(:user)
        user.cas_name.should == "testCAS"
      end

    end
  end

  describe "PUT update/:id" do

    before do
      @admin = FactoryGirl.create(:admin_user) 
      @user = FactoryGirl.create(:user)
      set_current_user @admin
    end

    describe "admin updates other user with valid params" do
      before(:each) do
        put :update, {id: @user, user: valid_params}, valid_session
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
        put :update, {id: @admin, user: valid_params}, valid_session
        controller.current_user.should == @admin
      end
    end

    describe "normal user" do
      before do
        set_current_user @user
      end

      it "cannot update another user's password" do
        other_user = FactoryGirl.create(:user, :name => "Jane" )
        put :update, {id: other_user, user: valid_params}, valid_session
        response.should redirect_to root_path
        other_user.reload
        other_user.name.should == "Jane"
      end
    end

  end
end
