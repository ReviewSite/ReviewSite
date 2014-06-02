require 'spec_helper'

describe SelfAssessmentsController do
  before(:each) do
    @user = FactoryGirl.create(:user)
    set_current_user (@user)
    @jc = FactoryGirl.create(:junior_consultant, :user => @user)
    @review = FactoryGirl.create(:review, :junior_consultant => @jc)
  end

  def valid_attributes
    {
       response: "My Response"
    }
  end

  def valid_session
    {
        userinfo: "info@email.com"
    }
  end

  describe "GET new" do
    it "assigns a new self_assessment as @self_assessment" do
      get :new, {:review_id => @review.id}, valid_session
      assigns(:self_assessment).should be_a_new(SelfAssessment)
    end
  end

  describe "GET edit" do
    it "assigns the requested self_assessment as @self_assessment" do
      self_assessment = FactoryGirl.create(:self_assessment, :review => @review)
      get :edit, {:id => self_assessment.to_param, :review_id => @review.id}, valid_session
      assigns(:self_assessment).should eq(self_assessment)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new SelfAssessment" do
        expect {
          post :create, {:self_assessment => valid_attributes, :review_id => @review.id}, valid_session
        }.to change(SelfAssessment, :count).by(1)
      end

      it "assigns a newly created self_assessment as @self_assessment" do
        post :create, {:self_assessment => valid_attributes, :review_id => @review.id}, valid_session
        assigns(:self_assessment).should be_a(SelfAssessment)
        assigns(:self_assessment).should be_persisted
      end

      it "redirects to the created self_assessment" do
        post :create, {:self_assessment => valid_attributes, :review_id => @review.id}, valid_session
        response.should redirect_to(summary_review_path(@review))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved self_assessment as @self_assessment" do
        # Trigger the behavior that occurs when invalid params are submitted
        SelfAssessment.any_instance.stub(:save).and_return(false)
        post :create, {:self_assessment => {}, :review_id => @review.id}, valid_session
        assigns(:self_assessment).should be_a_new(SelfAssessment)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        SelfAssessment.any_instance.stub(:save).and_return(false)
        post :create, {:self_assessment => {}, :review_id => @review.id}, valid_session
        response.should render_template("new")
      end
    end
    describe "when creating a self-assessment for another person" do
      before(:each) do
        @new_review = FactoryGirl.create(:review)
      end
      it "cannot succeed" do
        post :create, {:self_assessment => valid_attributes, :review_id => @new_review.id}, valid_session
        response.should redirect_to(root_path)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested self_assessment" do
        self_assessment = FactoryGirl.create(:self_assessment, :review => @review)
        # Assuming there are no other self_assessments in the database, this
        # specifies that the SelfAssessment created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        SelfAssessment.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => self_assessment.to_param, :self_assessment => {'these' => 'params'}, :review_id => @review.id}, valid_session
      end

      it "assigns the requested self_assessment as @self_assessment" do
        self_assessment = FactoryGirl.create(:self_assessment, :review => @review)
        put :update, {:id => self_assessment.to_param, :self_assessment => valid_attributes, :review_id => @review.id}, valid_session
        assigns(:self_assessment).should eq(self_assessment)
      end

      it "redirects to the self_assessment" do
        self_assessment = FactoryGirl.create(:self_assessment, :review => @review)
        put :update, {:id => self_assessment.to_param, :self_assessment => valid_attributes, :review_id => @review.id}, valid_session
        response.should redirect_to(summary_review_path(@review))
      end
    end

    describe "with invalid params" do
      it "assigns the self_assessment as @self_assessment" do
        self_assessment = FactoryGirl.create(:self_assessment, :review => @review)
        # Trigger the behavior that occurs when invalid params are submitted
        SelfAssessment.any_instance.stub(:save).and_return(false)
        put :update, {:id => self_assessment.to_param, :self_assessment => {}, :review_id => @review.id}, valid_session
        assigns(:self_assessment).should eq(self_assessment)
      end

      it "re-renders the 'edit' template" do
        self_assessment = FactoryGirl.create(:self_assessment, :review => @review)
        # Trigger the behavior that occurs when invalid params are submitted
        SelfAssessment.any_instance.stub(:save).and_return(false)
        put :update, {:id => self_assessment.to_param, :self_assessment => {}, :review_id => @review.id}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested self_assessment" do
      self_assessment = FactoryGirl.create(:self_assessment, :review => @review)
      expect {
        delete :destroy, {:id => self_assessment.to_param, :review_id => @review.id}, valid_session
      }.to change(SelfAssessment, :count).by(-1)
    end

    it "redirects to the self_assessments list" do
      self_assessment = FactoryGirl.create(:self_assessment, :review => @review)
      delete :destroy, {:id => self_assessment.to_param, :review_id => @review.id}, valid_session
      response.should redirect_to(summary_review_path(@review))
    end
  end

end
