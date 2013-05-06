require 'spec_helper'

describe UsersController do
  def valid_params
    {
        name: 'Joe',
        email: 'joe@example.com',
        password: 'password',
        password_confirmation: 'password',
        cas_name: 'JoeCAS'
    }
  end
  describe "#create" do
    context "Normal user registers another user" do
      before do
        user = FactoryGirl.create(:user)
        set_current_user user
      end

      it "should be forbidden" do
        post :create, {user: valid_params}
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
        post :create, {user: valid_params}
      end

      it 'should set the flash message' do
        post :create, {user: valid_params}
        flash[:success].should_not be_nil
      end

      it 'should redirect to the root path' do
        post :create, {user: valid_params}
        response.should redirect_to root_path
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
      set_current_user @admin
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
        set_current_user @user
      end

      it "cannot update another user's password" do
        other_user = FactoryGirl.create(:user, :name => "Jane" )
        put :update, id: other_user, user: valid_params
        response.should redirect_to root_path
        other_user.reload
        other_user.name.should == "Jane"
      end
    end

    describe "nil user" do
      before do
        set_current_user double(cas_name: nil, admin: false)
      end

      it "cannot edit a user with no set cas_name" do
        other_user = FactoryGirl.create(:user, name: "Jane", cas_name: nil)
        put :update, id: other_user, user: valid_params
        response.should redirect_to signin_path
        other_user.reload
        other_user.name.should == "Jane"
      end
    end
  end
end
