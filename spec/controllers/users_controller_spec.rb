require 'spec_helper'

describe UsersController do
  def valid_params
    {
        name: 'Joe',
        email: 'joe@example.com',
        okta_name: 'JoeCAS',
        admin: false
    }
  end

  def valid_ac_params
    {
        name: 'Joe',
        email: 'joe@example.com',
        okta_name: 'JoeCAS',
        admin: false,
        associate_consultant_attributes: {
          program_start_date: Date.new(2014,7,8),
          reviewing_group_id: create(:reviewing_group).id
        }
    }
  end

  def invalid_ac_params
    {
      name: 'Joe',
      email: 'joe@example.com',
      okta_name: 'JoeCAS',
      admin: false,
      associate_consultant_attributes: {
        program_start_date: nil,
        reviewing_group_id: create(:reviewing_group).id
      }
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
        user = create(:user)
        set_current_user user
      end

      it "should be forbidden" do
        post :create, {user: valid_params}, valid_session
        response.should redirect_to root_path
      end
    end

    context "Admin registers a user" do
      before do
        admin = create(:admin_user)
        set_current_user admin
      end

      it 'should not sign in the newly created user' do
        controller.should_not_receive(:set_current_user)
        post :create, {user: valid_params}, valid_session
      end

      it 'should create reviews for ac' do
        reviews = [double(Review).as_null_object]
        Review.stub!(:create_default_reviews).and_return(reviews)
        Review.should_receive(:create_default_reviews)

        post :create, {user: valid_ac_params, isac: 1}, valid_session
      end

      it 'should email the AC after reviews are created' do
        reviews = [double(Review).as_null_object]
        Review.stub!(:create_default_reviews).and_return(reviews)

        message = double(Mail::Message)
        message.should_receive(:deliver)
        UserMailer.stub!(:reviews_creation).and_return(message)
        UserMailer.should_receive(:reviews_creation).with(reviews[0])

        post :create, {user: valid_ac_params, isac: 1}, valid_session
      end

      it 'should not create reviews when ac lacks start date' do
        Review.should_not_receive(:create_default_reviews)
        post :create, {user: invalid_ac_params, isac: 1}, valid_session
        user = assigns(:user)

        user.associate_consultant.reviews.size.should == 0
      end

      it 'should set the flash message' do
        post :create, {user: valid_params}, valid_session
        flash[:success].should_not be_nil
      end

      it 'should redirect to the users page' do
        post :create, {user: valid_params}, valid_session
        response.should redirect_to users_url
      end
    end

    context "Users registers him/herself" do
      it 'should set the okta_name to the already authenticated okta name' do
        controller.current_okta_name = "testOKTA"
        post :create, {user: {name: "Test", email: "test@example.com", okta_name: "testOKTA", admin: false}}, valid_session
        user = assigns(:user)
        user.okta_name.should == "testOKTA"
      end

    end
  end

  describe '#feedbacks' do
    let(:user) { create(:user) }
    before do
      set_current_user user
    end

    it 'should assign unsubmitted feedbacks belonging to the user' do
      feedbacks = create_list(:feedback, 2, user: user)
      get :feedbacks, {id: user}, valid_session
      assigns(:feedbacks).should =~ feedbacks
    end

    it 'should not assign submitted feedbacks' do
      unsubmitted_feedback = create(:feedback, user: user)
      submitted_feedback = create(:submitted_feedback, user: user)
      get :feedbacks, {id: user}, valid_session
      assigns(:feedbacks).should_not include(submitted_feedback)
    end

    it 'should assign invitations sent to the primary email address of the user' do
      invitations = create_list(:invitation, 2, email: user.email)
      get :feedbacks, {id: user}, valid_session
      assigns(:invitations).should =~ invitations
    end

    it 'should assign invitations sent to a confirmed additional email of the user' do
      additional_email = create(:additional_email, user: user, confirmed_at: Date.today)
      invitation = create(:invitation, email: additional_email.email)
      get :feedbacks, {id: user}, valid_session
      assigns(:invitations).should include(invitation)
    end

    it 'should not assign invitations sent to an unconfirmed additional email' do
      additional_email = create(:additional_email, user: user)
      invitation = create(:invitation, email: additional_email.email)
      get :feedbacks, {id: user}, valid_session
      assigns(:invitations).should_not include(invitation)
    end

    it 'should not assign invitations that have an associated feedback' do
      invitation = create(:invitation, email: user.email)
      feedback = create(:feedback, user: user, review: invitation.review)
      get :feedbacks, {id: user}, valid_session
      assigns(:invitations).should_not include(invitation)
    end
  end

  describe "PUT update/:id" do

    before(:each) do
      @admin = create(:admin_user)
      @user = create(:user)
      set_current_user @admin
    end

    describe "admin makes user an AC" do
      it "should now have user as AC" do
        put :update, {id: @user, user: valid_ac_params, isac: 1}, valid_session

        user = assigns(:user)
        user.associate_consultant.should_not be_nil
      end

      it "should create four reviews for the AC" do
        reviews = [double(Review).as_null_object]
        Review.stub!(:create_default_reviews).and_return(reviews)
        Review.should_receive(:create_default_reviews)

        put :update, {id: @user, user: valid_ac_params, isac: 1}, valid_session
      end

      it 'should email the AC after reviews are created' do
        reviews = [double(Review).as_null_object]
        Review.stub!(:create_default_reviews).and_return(reviews)

        message = double(Mail::Message)
        message.should_receive(:deliver)
        UserMailer.stub!(:reviews_creation).and_return(message)
        UserMailer.should_receive(:reviews_creation).with(reviews[0])

        put :update, {id: @user, user: valid_ac_params, isac: 1}, valid_session
      end

      it "should not have reviews if there is no start date" do
        @user.associate_consultant = create(:associate_consultant, :program_start_date => nil)
        @user.save!
        Review.should_not_receive(:create_default_reviews)

        put :update, {id: @user, user: invalid_ac_params, isac: 1}, valid_session
        user = assigns(:user)
        user.associate_consultant.reviews.size.should == 0
      end
    end

    describe "admin updates other user with valid params" do
      before(:each) do
        put :update, {id: @user, user: valid_params}, valid_session
      end

      it "should redirect to users page" do
        response.should redirect_to users_url
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
        other_user = create(:user, :name => "Jane" )
        put :update, {id: other_user, user: valid_params}, valid_session
        response.should redirect_to root_path
        other_user.reload
        other_user.name.should == "Jane"
      end
    end

  end
end
