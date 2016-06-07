require 'spec_helper'

describe FeedbacksController do
  before(:each) do
    @review = create(:review)
    @user = create(:user)
    @project_worked_on = "Death Star II"
    @role_description = "Independent Contractor"
    @role_competence_to_be_improved = "Needs to learn rails"
    @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
    set_current_user(@user)
    Ability.any_instance.stub(:can?).and_return(true)
  end

  def valid_attributes
    { review_id: @review.id,
      user_id: @user.id,
      project_worked_on: @project_worked_on,
      role_description: @role_description,
      role_competence_to_be_improved: @role_competence_to_be_improved}
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
      feedback = create(:feedback, :submitted => true, :review => @review, :user => @user)
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
      feedback = create(:feedback, :review => @review, :user => @user)
      get :new, {:review_id => @review.id}, valid_session
      assigns(:feedback).should eq(feedback)
      assigns(:user_name).should eq(@user.name)
    end

    describe "when the user already has existing NAMED feedback" do
      before(:each) do
        feedback = create(:feedback, :review => @review, :user => @user, :user_string => "John Doe")
      end

      it "should create a new feedback" do
        get :new, {:review_id => @review.id}, valid_session
        assigns(:feedback).should be_a_new(Feedback)
        assigns(:user_name).should eq(@user.name)
      end
    end
  end

  describe "GET new_additional" do
    it "should create a new external feedback" do
      get :new_additional, {review_id: @review.id}, valid_session
      assigns(:feedback).should be_a_new(Feedback)
      assigns(:user_name).should eq(@user.name)
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

  describe "GET edit_additional" do
    it "assigns the requested feedback as @feedback" do
      feedback = Feedback.create! valid_attributes
      get :edit_additional, {id: feedback.to_param, review_id: @review.id}, valid_session
      assigns(:feedback).should eq(feedback)
      assigns(:user_name).should eq(@user.name)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Feedback" do
        expect {
          post :create, {
            :feedback => {
              :project_worked_on => @project_worked_on,
              :role_description => @role_description,
              :role_competence_to_be_improved => @role_competence_to_be_improved
            },
            :review_id => @review.id,
           }, valid_session
        }.to change(Feedback, :count).by(1)
      end

      it "assigns a newly created feedback as @feedback" do
        post :create, {
            :feedback => {
                :project_worked_on => @project_worked_on,
                :role_description => @role_description,
                :role_competence_to_be_improved => @role_competence_to_be_improved
            },
            :review_id => @review.id,
        }, valid_session
        assigns(:feedback).should be_a(Feedback)
        assigns(:feedback).should be_persisted
        assigns(:feedback).user.should eq(@user)
        assigns(:feedback).review.should eq(@review)
      end

      it "sets the submitted to false by default" do
        post :create, {
            :feedback => {
                :project_worked_on => @project_worked_on,
                :role_description => @role_description,
                :role_competence_to_be_improved => @role_competence_to_be_improved
            },
            :review_id => @review.id,
        }, valid_session
        assigns(:feedback).submitted.should == false
      end

      it "sets the submitted to true if clicked on the 'Submit Final' button" do
        post :create, {
            :feedback => {
                :project_worked_on => @project_worked_on,
                :role_description => @role_description,
                :role_competence_to_be_improved => @role_competence_to_be_improved
            },
            :review_id => @review.id,
            :submit_final_button => 'Submit Final'
        }, valid_session
        assigns(:feedback).reload
        assigns(:feedback).submitted.should == true
      end

      it "sends a notification email if clicked on the 'Submit Final' button" do
        UserMailer.should_receive(:new_feedback_notification).and_return(double(deliver: true))
        UserMailer.should_receive(:new_feedback_notification_coach).and_return(double(deliver: true))
        post :create, {
            :feedback => {
                :project_worked_on => @project_worked_on,
                :role_description => @role_description,
                :role_competence_to_be_improved => @role_competence_to_be_improved
            },
            :review_id => @review.id,
            :submit_final_button => 'Submit Final'
        }, valid_session
      end

      it "redirects to the created feedback edit path" do
        post :create, {
          :feedback => {
            :project_worked_on => @project_worked_on,
            :role_description => @role_description,
            :role_competence_to_be_improved => @role_competence_to_be_improved
          },
          :review_id => @review.id
        }, valid_session
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
        put :update, {:id => feedback.to_param, :feedback => feedback, :review_id => @review.id}, valid_session
        assigns(:feedback).should be_a (Feedback)
        assigns(:feedback).user.should eq(@user)
        assigns(:feedback).review.should eq(@review)
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

    it "displays a success message" do
      feedback = Feedback.create! valid_attributes
      delete :destroy, {:id => feedback.to_param, :review_id => @review.id}, valid_session
      flash[:success].should == "You have successfully deleted your feedback for #{@review.reviewee}."
    end

    it "displays a different success message when AC is deleting external feedback" do
      feedback = Feedback.create! valid_attributes
      feedback.update_attribute(:reported_by, Feedback::SELF_REPORTED)
      delete :destroy, {:id => feedback.to_param, :review_id => @review.id}, valid_session
      flash[:success].should == "You have successfully deleted the external feedback recorded from #{feedback.reviewer}."
    end
  end

  describe "POST send_reminder" do
    describe "without submitted feedback" do
      let! (:feedback) { create(:feedback, review: @review, user: @user) }

      it "redirects to the review" do
        post :send_reminder, {id: feedback.to_param, review_id: @review.id}, valid_session
        response.should redirect_to(@review)
      end

      it "notifies that email has been sent" do
        post :send_reminder, {id: feedback.to_param, review_id: @review.id}, valid_session
        flash[:success].should == "Reminder email was sent!"
      end

      it "delivers an email with the correct content" do
        ActionMailer::Base.deliveries.clear
        post :send_reminder, {id: feedback.to_param, review_id: @review.id}, valid_session
        num_deliveries = ActionMailer::Base.deliveries.size
        num_deliveries.should == 1
        message = ActionMailer::Base.deliveries.first
        message.to.should == [@user.email]
        message.body.encoded.should match("You have saved feedback, but it has not yet been submitted. To continue working, please visit")
      end
    end

    describe "with submitted feedback" do
      let! (:feedback) { create(:submitted_feedback, review: @review, user: @user) }

      it "redirects to the review" do
        post :send_reminder, {id: feedback.to_param, review_id: @review.id}, valid_session
        response.should redirect_to(@review)
      end

      it "notifies that email has not been sent" do
        post :send_reminder, {id: feedback.to_param, review_id: @review.id}, valid_session
        flash[:alert].should == "Feedback already submitted. Reminder not sent."
      end

      it "does not send an email" do
        expect do
          post :send_reminder, {id: feedback.to_param, review_id: @review.id}, valid_session
        end.to change{ ActionMailer::Base.deliveries.length }.by(0)
      end
    end
  end
end
