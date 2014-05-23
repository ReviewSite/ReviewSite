require 'spec_helper'

describe ReviewsController do

  # This should return the minimal set of attributes required to create a valid
  # Review. As you add validations to Review, be sure to
  # update the return value of this method accordingly.

  let(:jc) {FactoryGirl.create(:junior_consultant)}

  def valid_attributes
    {
        review_type: '6-Month',
        junior_consultant_id: jc.user.name,
        review_date: Date.today,
        feedback_deadline: Date.today,
        send_link_date: Date.today
    }
  end

  def valid_session
    { userinfo: "test@test.com"}
  end

  describe "GET index" do
    let(:review) { FactoryGirl.build(:review) }
    let(:user) { FactoryGirl.build(:user) }

    before do
        User.stub(:find_by_okta_name).and_return(user)
        set_current_user user
        Review.stub(:includes).and_return(Review)
        Review.stub(:all).and_return([review])
    end

    context 'user has permission to view review summary' do
      before do
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
  end

  describe "GET show" do
    let(:admin_user) { FactoryGirl.create(:admin_user) }
    before(:each) do
      set_current_user admin_user
    end
    it "assigns the requested review as @review" do
      review = FactoryGirl.create(:review)
      get :show, {:id => review.to_param}, valid_session
      assigns(:review).should eq(review)
    end
  end

  describe "GET summary" do

    before(:each) do
      @review = FactoryGirl.create(:review)
      @feedback_sub = FactoryGirl.create(:submitted_feedback, :review => @review)
      @feedback_unsub = FactoryGirl.create(:feedback, :review => @review)
      @admin_user = FactoryGirl.create(:admin_user)
      set_current_user @admin_user
    end

    it "assigns ONLY submitted feedback as @feedbacks" do
      get :summary, {:id => @review.to_param}, valid_session
      response.should be_success
      assigns(:feedbacks).should eq([@feedback_sub])
    end

    it "can be seen by the feedback target" do
      @jc_user = @review.junior_consultant.user
      set_current_user @jc_user

      get :summary, {:id => @review.to_param}, valid_session
      response.should be_success
      assigns(:feedbacks).should eq([@feedback_sub])
    end

    describe "JC coach" do
      it "can see the summary for their coachee" do
        junior_consultant = @review.junior_consultant
        coach = FactoryGirl.create(:user)
        junior_consultant.coach = coach
        junior_consultant.save!
        set_current_user coach
        get :summary, {:id => @review.to_param}, valid_session
        response.should be_success
        assigns(:feedbacks).should eq([@feedback_sub])
      end

      it "can't see the summary for other coachees" do
        junior_consultant = @review.junior_consultant
        coach = FactoryGirl.create(:user)
        junior_consultant.save!

        set_current_user coach
        get :summary, {:id => @review.to_param}, valid_session
        response.should_not be_success
        assigns(:feedbacks).should_not eq([@feedback_sub])
      end
    end

    describe "with a reviewing group member" do
      it "the reviewing member can see the summary" do
        junior_consultant = @review.junior_consultant
        other_user = FactoryGirl.create(:user)
        reviewing_group = FactoryGirl.create(:reviewing_group, :users => [other_user])

        junior_consultant.reviewing_group = reviewing_group
        junior_consultant.save!

        set_current_user other_user
        get :summary, {:id => @review.to_param}, valid_session
        response.should be_success
      end
    end
  end

  describe "GET new" do
    it "assigns a new review as @review" do
      admin_user = FactoryGirl.create(:admin_user)
      set_current_user admin_user
      get :new, {}, valid_session
      assigns(:review).should be_a_new(Review)
    end
  end
  describe "when signed out" do
    it "cannot GET new" do
      get :new, {}, valid_session
      response.should redirect_to(signin_path)
    end
    it "cannot GET edit" do
      review = Review.create! valid_attributes
      get :edit, {:id => review.to_param}, valid_session
      response.should redirect_to(signin_path)
    end
    it "cannot POST create" do
      review = Review.create! valid_attributes
      post :create, {:review => valid_attributes}, valid_session
      response.should redirect_to(signin_path)
    end
    it "cannot PUT update" do
      review = Review.create! valid_attributes
      put :update, {:id => review.to_param, :review => valid_attributes}, valid_session
      response.should redirect_to(signin_path)
    end
    it "cannot DELETE destroy" do
      review = Review.create! valid_attributes
      delete :destroy, {:id => review.to_param}, valid_session
      response.should redirect_to(signin_path)
    end
  end

  describe "GET edit" do
    let(:admin_user) { FactoryGirl.create(:admin_user) }
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
    let(:admin_user) { FactoryGirl.create(:admin_user) }
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
        post :create, {:review => { junior_consultant_id: jc.user.name}}, valid_session
        assigns(:review).should be_a_new(Review)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Review.any_instance.stub(:save).and_return(false)
        post :create, {:review => {junior_consultant_id: jc.user.name}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    let(:admin_user) { FactoryGirl.create(:admin_user) }
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

  describe "DELETE destroy" do
    let(:admin_user) { FactoryGirl.create(:admin_user) }
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

end
