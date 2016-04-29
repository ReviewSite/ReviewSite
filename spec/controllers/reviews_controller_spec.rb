require 'spec_helper'
describe ReviewsController do

  # This should return the minimal set of attributes required to create a valid
  # Review. As you add validations to Review, be sure to
  # update the return value of this method accordingly.

  let(:ac) { create(:associate_consultant) }

  def valid_attributes
    {
        review_type: '6-Month',
        associate_consultant_id: ac.id,
        review_date: Date.today,
        feedback_deadline: 1.day.ago,
    }
  end

  def valid_session
    {userinfo: "test@test.com"}
  end

  describe "GET index" do
    let(:review) { create(:review) }
    let(:user) { create(:user) }

    before do
      User.stub(:find_by_okta_name).and_return(user)
      set_current_user user
      Review.stub(:includes).and_return(Review)
      Review.stub(:all).and_return([review])
    end

    context 'user has permission to view review summary' do
      before do
        Review.stub(:accessible_by).and_return([review])
        controller.stub(:can?).and_return(true)
      end

      it 'should assign all the reviews the user can summarize' do
        get :index, {}, valid_session
        assigns(:reviews).should =~ [review]
      end
    end

    context 'user does not have permission to view review summary' do
      before do
        controller.stub(:car?).and_return(false)
      end

      it 'should not assign reviews that the user can not summarize' do
        get :index, {}, valid_session
        assigns(:reviews).should == []
      end
    end

    context 'user is both AC and Coach' do
      before do
        @associate_consultant = create(:associate_consultant)
        @associate_consultant.user = user
        @associate_consultant.save!
        user.save!
        Review.create_default_reviews(@associate_consultant)
        @coachee = create(:associate_consultant)
        @coachee.coach = user
        @coachee.save!
        Review.create_default_reviews(@coachee)
        Review.stub(:accessible_by).and_return(@associate_consultant.reviews)
      end
      it 'should by default show only the user\'s reviews' do
        get :index, {}, valid_session
        assigns(:reviews) == @associate_consultant.reviews
      end

    end

    context 'user is not an AC' do
      before do
        @coachee = create(:associate_consultant)
        @coachee.coach = user
        @coachee.save!
        Review.create_default_reviews(@coachee)
        Review.stub(:accessible_by).and_return(@coachee.reviews)
      end

      it 'should always show the coachee/watched reviews' do
        get :index, {}, valid_session
        assigns(:reviews).should eq(@coachee.reviews)
      end
    end
  end

  describe "GET coachees" do
    let(:user) { create(:user) }
    before do
      @coachee = create(:associate_consultant)
      @coachee.coach = user
      @coachee.save!
      Review.create_default_reviews(@coachee)
      Review.stub(:accessible_by).and_return(@coachee.reviews)
    end

    it 'should show coachee reviews' do
      get :coachees, {}, valid_session
      assigns(:reviews).should eq(@coachee.reviews.default_load)
    end
  end

  describe "GET show" do
    let(:admin_user) { create(:admin_user) }
    before(:each) do
      set_current_user admin_user
    end
    it "assigns the requested review as @review" do
      review = create(:review)
      get :show, {:id => review.to_param}, valid_session
      assigns(:review).should eq(review)
    end
  end

  describe "GET summary" do

    before(:each) do
      @review = create(:review)
      @feedback_sub = create(:submitted_feedback, :review => @review)
      @feedback_unsub = create(:feedback, :review => @review)
      @admin_user = create(:admin_user)
      set_current_user @admin_user
    end

    it "assigns ONLY submitted feedback as @feedbacks" do
      get :summary, {:id => @review.to_param}, valid_session
      response.should be_success
      assigns(:feedbacks).should eq([@feedback_sub])
    end

    it "can be seen by the feedback target" do
      @ac_user = @review.associate_consultant.user
      set_current_user @ac_user

      get :summary, {:id => @review.to_param}, valid_session
      response.should be_success
      assigns(:feedbacks).should eq([@feedback_sub])
    end

    it "should call responder's xlsx method" do
      get :summary, {id: @review.to_param, format: :xlsx}, valid_session
      response.content_type.should include 'openxmlformats'
    end

    describe "AC coach" do
      it "can see the summary for their coachee" do
        associate_consultant = @review.associate_consultant
        coach = create(:user)
        associate_consultant.coach = coach
        associate_consultant.save!
        set_current_user coach
        get :summary, {:id => @review.to_param}, valid_session
        response.should be_success
        assigns(:feedbacks).should eq([@feedback_sub])
      end

      it "can't see the summary for other coachees" do
        associate_consultant = @review.associate_consultant
        coach = create(:user)
        associate_consultant.save!

        set_current_user coach
        get :summary, {:id => @review.to_param}, valid_session
        response.should_not be_success
        assigns(:feedbacks).should_not eq([@feedback_sub])
      end
    end

    describe "with a reviewing group member" do
      it "the reviewing member can see the summary" do
        associate_consultant = @review.associate_consultant
        other_user = create(:user)
        reviewing_group = create(:reviewing_group, :users => [other_user])

        associate_consultant.reviewing_group = reviewing_group
        associate_consultant.save!

        set_current_user other_user
        get :summary, {:id => @review.to_param}, valid_session
        response.should be_success
      end
    end
  end

  describe "GET new" do
    it "assigns a new review as @review" do
      admin_user = create(:admin_user)
      set_current_user admin_user
      get :new, {}, valid_session
      assigns(:review).should be_a_new(Review)
    end
  end

  describe "when signed out" do
  end

  describe "GET edit" do
    let(:admin_user) { create(:admin_user) }
    before(:each) do
      set_current_user admin_user
    end
    it "assigns the requested review as @review" do
      review = Review.create! valid_attributes
      get :edit, {:id => review.to_param}, valid_session
      assigns(:review).should eq(review)
    end
  end

  describe "POST create" do
    let(:admin_user) { create(:admin_user) }
    before(:each) do
      set_current_user admin_user
    end
    describe "with valid params" do
      it "creates a new Review" do
        expect {
          post :create, {:review => valid_attributes}, valid_session
        }.to change(Review, :count).by(1)
      end

      it "assigns a newly created review as @review" do
        post :create, {:review => valid_attributes}, valid_session
        assigns(:review).should be_a(Review)
        assigns(:review).should be_persisted
      end

      it "redirects to the created review" do
        post :create, {:review => valid_attributes}, valid_session
        response.should redirect_to(Review.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved review as @review" do
        # Trigger the behavior that occurs when invalid params are submitted
        Review.any_instance.stub(:save).and_return(false)
        post :create, {:review => {associate_consultant_id: ac.user.name}}, valid_session
        assigns(:review).should be_a_new(Review)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Review.any_instance.stub(:save).and_return(false)
        post :create, {:review => {associate_consultant_id: ac.user.name}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    context 'as an admin' do
      let(:admin_user) { create(:admin_user) }
      before(:each) do
        set_current_user admin_user
      end

      describe "with valid params" do
        it "updates the requested review" do
          review = Review.create! valid_attributes
          # Assuming there are no other reviews in the database, this
          # specifies that the Review created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Review.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => review.to_param, :review => {'these' => 'params'}}, valid_session
        end

        it "assigns the requested review as @review" do
          review = Review.create! valid_attributes
          put :update, {:id => review.to_param, :review => valid_attributes}, valid_session
          assigns(:review).should eq(review)
        end

        it "redirects to the review" do
          review = Review.create! valid_attributes
          put :update, {:id => review.to_param, :review => valid_attributes}, valid_session
          response.should redirect_to(review)
        end
      end

      describe "with invalid params" do
        it "assigns the review as @review" do
          review = Review.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Review.any_instance.stub(:save).and_return(false)
          put :update, {:id => review.to_param, :review => {}}, valid_session
          assigns(:review).should eq(review)
        end

        it "re-renders the 'edit' template" do
          review = Review.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Review.any_instance.stub(:save).and_return(false)
          put :update, {:id => review.to_param, :review => {}}, valid_session
          response.should render_template("edit")
        end
      end
    end

    context 'as a user' do
      let(:review_user) { create(:user) }
      let(:ac) { create(:associate_consultant, user: review_user) }
      before(:each) do
        @review = Review.create! valid_attributes
        @review.update_attribute(:associate_consultant_id, ac.id)
        @review.update_attribute(:review_date, @review.review_date + 1.month)
        @review.update_attribute(:reviewee, ac.user)
        set_current_user ac.user
      end

      describe "with valid params" do
        it "updates the requested review" do
          Review.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => @review.to_param, :review => {'these' => 'params'}}, valid_session
        end
      end

      it "should notify invitees when the deadline changes" do
        @review.invitations << FactoryGirl.create_list(:invitation, 5)
        UserMailer.should_receive(:review_update).exactly(@review.invitations.count).times.and_return(double(deliver: true))
        put :update, {:id => @review.to_param, :review => {'feedback_deadline' => @review.feedback_deadline - 2.weeks,
                                                           'review_date' => @review.review_date}}, valid_session
      end

      it "should not notify invitees when the deadline doesn't change" do
        @review.invitations << FactoryGirl.create_list(:invitation, 5)
        UserMailer.should_receive(:review_update).exactly(0).times.and_return(double(deliver: true))
        put :update, {:id => @review.to_param,
                      :review => {'feedback_deadline' => @review.feedback_deadline,
                                  'review_date' => @review.review_date}}, valid_session
      end

      it "should not notify invitees when the review date changes" do
        @review.invitations << FactoryGirl.create_list(:invitation, 5)
        UserMailer.should_receive(:review_update).exactly(0).times.and_return(double(deliver: true))
        put :update, {:id => @review.to_param,
                      :review => {'feedback_deadline' => @review.feedback_deadline,
                                  'review_date' => @review.review_date + 2.months}}, valid_session
      end
    end
  end

  describe "DELETE destroy" do
    let(:admin_user) { create(:admin_user) }
    before(:each) do
      set_current_user admin_user
    end
    it "destroys the requested review" do
      review = Review.create! valid_attributes
      expect {
        delete :destroy, {:id => review.to_param}, valid_session
      }.to change(Review, :count).by(-1)
    end

    it "redirects to the reviews list" do
      review = Review.create! valid_attributes
      delete :destroy, {:id => review.to_param}, valid_session
      response.should redirect_to(root_url)
    end
  end

  describe "SEND email" do
    let(:admin_user) { create(:admin_user) }
    let(:user) { create(:user) }
    let(:ac) { create(:associate_consultant, :user => user) }
    let(:review) { create(:review, :associate_consultant => ac) }
    before(:each) do
      set_current_user admin_user
    end

    it "should show send email on review creation" do
      get :send_email, {:id => review.to_param}, valid_session
      response.should be_success
    end
  end

  describe "POST send reminder to all" do
    let(:ac_user) { create(:user) }
    let(:ac) { create(:associate_consultant, user: ac_user) }
    let(:review) { create(:review, associate_consultant: ac) }
    let(:unsubmitted_feedback_reviewer) { create(:user) }
    let(:submitted_feedback_reviewer) { create(:user) }
    let(:invited_reviewer) { create(:user) }

    let! (:feedback) { create(:feedback, review: review, user: unsubmitted_feedback_reviewer) }
    let! (:submitted_feedback) { create(:submitted_feedback, review: review, user: submitted_feedback_reviewer) }
    let! (:external_feedback) { create(:feedback, review: review, user: ac_user, reported_by: Feedback::SELF_REPORTED) }
    let! (:invitation) { review.invitations.create!(email: invited_reviewer.email) }

    it "should send an email reminder to users with invitations and unfinished feedback" do
      set_current_user ac_user
      ActionMailer::Base.deliveries.clear
      post :send_reminder_to_all, {id: review.to_param}, valid_session
      num_deliveries = ActionMailer::Base.deliveries.size
      num_deliveries.should == 2

      unsubmitted_feedback_email = ActionMailer::Base.deliveries.first
      unsubmitted_feedback_email.to.should == [unsubmitted_feedback_reviewer.email]

      invitation_email = ActionMailer::Base.deliveries.second
      invitation_email.to.should == [invited_reviewer.email]
    end
  end
end
