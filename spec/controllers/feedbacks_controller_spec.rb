require 'spec_helper'

describe FeedbacksController do
  before(:each) do
    @review = FactoryGirl.create(:review)
    @user = FactoryGirl.create(:user)
    set_current_user(@user)
    Ability.any_instance.stub(:can?).and_return(true)
  end

  def valid_attributes
    { review_id: @review.id,
      user_id: @user.id}
  end

  def valid_session
    {:userinfo => "test@test.com"}
  end

  describe "GET show" do
    it "assigns the requested feedback as @feedback" do
      feedback = Feedback.create! valid_attributes
      get :show, {:id => feedback.to_param, :review_id => @review.id}, valid_session
      assigns(:feedback).should eq(feedback)
    end

    it "CAN show feedback that has been 'submitted'" do
      feedback = FactoryGirl.create(:feedback, :submitted => true, :review => @review, :user => @user)
      get :show, {:id => feedback.to_param, :review_id => @review.id}, valid_session
      assigns(:feedback).should eq(feedback)
      response.should be_success
    end
  end

  describe "GET new" do
    before do
      @review.invitations.create(:email => @user.email)
    end

    it "assigns a new feedback as @feedback" do
      get :new, {:review_id => @review.id}, valid_session
      assigns(:feedback).should be_a_new(Feedback)
      assigns(:user_name).should eq(@user.name)
    end

    it "loads the existing feedback if one exists for this user" do
      feedback = FactoryGirl.create(:feedback, :review => @review, :user => @user)
      get :new, {:review_id => @review.id}, valid_session
      assigns(:feedback).should eq(feedback)
      assigns(:user_name).should eq(@user.name)
    end

    describe "when the user already has existing NAMED feedback" do
      before(:each) do
        feedback = FactoryGirl.create(:feedback, :review => @review, :user => @user, :user_string => "John Doe")
      end

      it "should create a new feedback" do
        get :new, {:review_id => @review.id}, valid_session
        assigns(:feedback).should be_a_new(Feedback)
        assigns(:user_name).should eq(@user.name)
      end

      it "loads the existing feedback if one exists for this user" do
        feedback = FactoryGirl.create(:feedback, :review => @review, :user => @user)
        get :new, {:review_id => @review.id}, valid_session
        assigns(:feedback).should eq(feedback)
        assigns(:user_name).should eq(@user.name)
      end
    end
  end

  describe "GET edit" do
    it "assigns the requested feedback as @feedback" do
      feedback = Feedback.create! valid_attributes
      get :edit, {:id => feedback.to_param, :review_id => @review.id}, valid_session
      assigns(:feedback).should eq(feedback)
      assigns(:user_name).should eq(@user.name)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Feedback" do
        expect {
          post :create, {:feedback => {}, :review_id => @review.id}, valid_session
        }.to change(Feedback, :count).by(1)
      end

      it "assigns a newly created feedback as @feedback" do
        post :create, {:feedback => {}, :review_id => @review.id}, valid_session
        assigns(:feedback).should be_a(Feedback)
        assigns(:feedback).should be_persisted
        assigns(:feedback).user.should eq(@user)
        assigns(:feedback).review.should eq(@review)
      end

      it "sets the submitted to false by default" do
        post :create, {:feedback => {}, :review_id => @review.id}, valid_session
        assigns(:feedback).submitted.should == false
      end

      it "sets the submitted to true if clicked on the 'Submit Final' button" do
        post :create, {:feedback => {}, :review_id => @review.id, :submit_final_button => 'Submit Final'}, valid_session
        assigns(:feedback).reload
        assigns(:feedback).submitted.should == true
      end

      it "sends a notification email if clicked on the 'Submit Final' button" do
        UserMailer.should_receive(:new_feedback_notification).and_return(double(deliver: true))
        UserMailer.should_receive(:new_feedback_notification_coach).and_return(double(deliver: true))
        post :create, {:feedback => {}, :review_id => @review.id, :submit_final_button => 'Submit Final'}, valid_session
      end

      it "redirects to the created feedback edit path" do
        post :create, {:feedback => {}, :review_id => @review.id}, valid_session
        response.should redirect_to(edit_review_feedback_path(@review.id, Feedback.last.id))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved feedback as @feedback" do
        # Trigger the behavior that occurs when invalid params are submitted
        Feedback.any_instance.stub(:save).and_return(false)
        post :create, {:feedback => {}, :review_id => @review.id}, valid_session
        assigns(:feedback).should be_a_new(Feedback)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Feedback.any_instance.stub(:save).and_return(false)
        post :create, {:feedback => {}, :review_id => @review.id}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested feedback" do
        feedback = Feedback.create! valid_attributes
        # Assuming there are no other feedbacks in the database, this
        # specifies that the Feedback created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Feedback.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => feedback.to_param, :feedback => {'these' => 'params'}, :review_id => @review.id}, valid_session
      end

      it "assigns the requested feedback as @feedback" do
        feedback = Feedback.create! valid_attributes
        put :update, {:id => feedback.to_param, :feedback => {}, :review_id => @review.id}, valid_session
        assigns(:feedback).should eq(feedback)
      end

      it "redirects to the feedback" do
        feedback = Feedback.create! valid_attributes
        put :update, {:id => feedback.to_param, :feedback => {}, :review_id => @review.id}, valid_session
        response.should redirect_to edit_review_feedback_path(@review, feedback)
      end

      it "sets the submitted to false by default" do
        feedback = Feedback.create! valid_attributes
        put :update, {:id => feedback.to_param, :feedback => {}, :review_id => @review.id}, valid_session
        assigns(:feedback).submitted.should == false
      end

      it "sets the submitted to true if clicked on the 'Submit Final' button" do
        feedback = Feedback.create! valid_attributes
        put :update, {:id => feedback.to_param, :feedback => {}, :review_id => @review.id, :submit_final_button => 'Submit Final'}, valid_session
        assigns(:feedback).submitted.should == true
      end

      it "sends a notification email if clicked on the 'Submit Final' button" do
        feedback = Feedback.create! valid_attributes
        UserMailer.should_receive(:new_feedback_notification).and_return(double(deliver: true))
        UserMailer.should_receive(:new_feedback_notification_coach).and_return(double(deliver: true))
        put :update, {:id => feedback.to_param, :feedback => {}, :review_id => @review.id, :submit_final_button => 'Submit Final'}, valid_session
      end
    end

    describe "with invalid params" do
      it "assigns the feedback as @feedback" do
        feedback = Feedback.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Feedback.any_instance.stub(:save).and_return(false)
        put :update, {:id => feedback.to_param, :feedback => {}, :review_id => @review.id}, valid_session
        assigns(:feedback).should eq(feedback)
      end

      it "re-renders the 'edit' template" do
        feedback = Feedback.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Feedback.any_instance.stub(:save).and_return(false)
        put :update, {:id => feedback.to_param, :feedback => {}, :review_id => @review.id}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested feedback" do
      feedback = Feedback.create! valid_attributes
      expect {
        delete :destroy, {:id => feedback.to_param, :review_id => @review.id}, valid_session
      }.to change(Feedback, :count).by(-1)
    end

    it "redirects to the feedbacks list" do
      feedback = Feedback.create! valid_attributes
      delete :destroy, {:id => feedback.to_param, :review_id => @review.id}, valid_session
      response.should redirect_to(root_url)
    end
  end

  describe "POST send_reminder" do
    it "should send a new invitation if the feedback doesn't have one" do
      feedback = Feedback.create! valid_attributes
      Invitation.stub(:new).and_return(:invitation)
      UserMailer.should_receive(:feedback_reminder).with(:invitation).and_return(double(deliver: true))
      post :send_reminder, {:review_id => @review.id, :id => feedback.id}, valid_session
    end

    it "creates an invitation with the email of the reviewer" do
      feedback = Feedback.create! valid_attributes
      post :send_reminder, {:review_id => @review.id, :id => feedback.id}, valid_session
      email = ActionMailer::Base.deliveries.last
      email.to.should == [feedback.user.email]
    end
  end
end
