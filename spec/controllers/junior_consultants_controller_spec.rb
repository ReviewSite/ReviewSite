require 'spec_helper'

describe JuniorConsultantsController do
  before(:each) do
    @rg = FactoryGirl.create(:reviewing_group)
    @coach = FactoryGirl.create(:user)
    @jc_user = FactoryGirl.create(:user)
  end

  def valid_attributes
    {
      reviewing_group_id: @rg.id,
      notes: "This is a dev",
      coach_id: @coach.name,
      user_id: @jc_user.name
    }
  end

  def valid_session
    {:userinfo => "test@test.com"}
  end

  describe "-- An ordinary user" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      set_current_user @user
    end

    it "cannot GET index on all JCs" do
      get :index, {}, valid_session
      response.should redirect_to(root_path)
    end

    it "cannot GET new on a JC" do
      get :new, {}, valid_session
      assigns(:junior_consultant).should be_a_new(JuniorConsultant)
      response.should redirect_to(root_path)
    end

    it "cannot GET edit on a JC" do
      junior_consultant = FactoryGirl.create(:junior_consultant)
      get :edit, {:id => junior_consultant.to_param}, valid_session
      response.should redirect_to(root_path)
    end

    it "cannot POST create on a JC" do
      post :create, {:junior_consultant => valid_attributes}, valid_session
      response.should redirect_to(root_path)
    end

    it "cannot PUT update on a JC" do
      junior_consultant = FactoryGirl.create(:junior_consultant)
      put :update, {:id => junior_consultant.to_param, :junior_consultant => valid_attributes}, valid_session
      response.should redirect_to(root_path)
    end

    it "cannot DELETE a jc" do
      junior_consultant = FactoryGirl.create(:junior_consultant)
      delete :destroy, {:id => junior_consultant.to_param}, valid_session
      response.should redirect_to(root_path)
    end
  end

  describe "-- A user not logged in" do
    it "cannot list all JCs" do
      get :index, {}, valid_session
      response.should redirect_to(signin_path)
    end
  end

  describe "-- Admin GET index" do
    before(:each) do
      @admin_user = FactoryGirl.create(:admin_user)
      set_current_user @admin_user
    end

    it "assigns all junior_consultants as @junior_consultants" do
      junior_consultant = FactoryGirl.create(:junior_consultant)
      get :index, {}, valid_session
      assigns(:junior_consultants).should eq([junior_consultant])
    end
  end

  describe "-- Admin GET new" do
    before(:each) do
      @admin_user = FactoryGirl.create(:admin_user)
      set_current_user @admin_user
    end

    it "assigns a new junior_consultant as @junior_consultant" do
      get :new, {}, valid_session
      assigns(:junior_consultant).should be_a_new(JuniorConsultant)
    end
  end

  describe "-- Admin GET edit" do
    before(:each) do
      @admin_user = FactoryGirl.create(:admin_user)
      set_current_user @admin_user
    end

    it "assigns the requested junior_consultant as @junior_consultant" do
      junior_consultant = FactoryGirl.create(:junior_consultant)
      get :edit, {:id => junior_consultant.to_param}, valid_session
      assigns(:junior_consultant).should eq(junior_consultant)
    end
  end

  describe "--Admin POST create" do
    before(:each) do
      @admin_user = FactoryGirl.create(:admin_user)
      set_current_user @admin_user
    end

    describe "with valid params" do
      it "creates a new JuniorConsultant" do
        expect {
          post :create, {:junior_consultant => valid_attributes}, valid_session
        }.to change(JuniorConsultant, :count).by(1)
      end

      it "assigns a newly created junior_consultant as @junior_consultant" do
        post :create, {:junior_consultant => valid_attributes}, valid_session
        assigns(:junior_consultant).should be_a(JuniorConsultant)
        assigns(:junior_consultant).should be_persisted
      end

      it "redirects to the junior_consultants index" do
        post :create, {:junior_consultant => valid_attributes}, valid_session
        response.should redirect_to(junior_consultants_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved junior_consultant as @junior_consultant" do
        # Trigger the behavior that occurs when invalid params are submitted
        JuniorConsultant.any_instance.stub(:save).and_return(false)
        post :create, {:junior_consultant => {}}, valid_session
        assigns(:junior_consultant).should be_a_new(JuniorConsultant)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        JuniorConsultant.any_instance.stub(:save).and_return(false)
        post :create, {:junior_consultant => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "-- Admin PUT update" do
    before(:each) do
      @admin_user = FactoryGirl.create(:admin_user)
      set_current_user @admin_user
    end
    describe "with valid params" do
      it "updates the requested junior_consultant" do
        junior_consultant = FactoryGirl.create(:junior_consultant)
        # Assuming there are no other junior_consultants in the database, this
        # specifies that the JuniorConsultant created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        JuniorConsultant.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => junior_consultant.to_param, :junior_consultant => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested junior_consultant as @junior_consultant" do
        user = FactoryGirl.create(:user)
        junior_consultant = FactoryGirl.create(:junior_consultant, :user => user)

        valid_attributes =
          { reviewing_group_id: @rg.id,
            notes: "This is a dev",
            coach_id: @coach.name,
            user_id: junior_consultant.user.name
          }

        put :update, {:id => junior_consultant.to_param, :junior_consultant => valid_attributes}, valid_session
        assigns(:junior_consultant).should eq(junior_consultant)
      end

      it "redirects to the junior_consultant" do
        junior_consultant = FactoryGirl.create(:junior_consultant)
        put :update, {:id => junior_consultant.to_param, :junior_consultant => {notes: "updated notes"}}, valid_session
        response.should redirect_to(junior_consultants_path)
      end
    end

    describe "with invalid params" do
      it "assigns the junior_consultant as @junior_consultant" do
        junior_consultant = FactoryGirl.create(:junior_consultant)
        # Trigger the behavior that occurs when invalid params are submitted
        JuniorConsultant.any_instance.stub(:save).and_return(false)
        put :update, {:id => junior_consultant.to_param, :junior_consultant => {}}, valid_session
        assigns(:junior_consultant).should eq(junior_consultant)
      end

      it "re-renders the 'edit' template" do
        junior_consultant = FactoryGirl.create(:junior_consultant)
        # Trigger the behavior that occurs when invalid params are submitted
        JuniorConsultant.any_instance.stub(:save).and_return(false)
        put :update, {:id => junior_consultant.to_param, :junior_consultant => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "-- Admin DELETE destroy" do
    before(:each) do
      @admin_user = FactoryGirl.create(:admin_user)
      set_current_user @admin_user
    end
    it "destroys the requested junior_consultant" do
      junior_consultant = FactoryGirl.create(:junior_consultant)
      expect {
        delete :destroy, {:id => junior_consultant.to_param}, valid_session
      }.to change(JuniorConsultant, :count).by(-1)
  end

    it "redirects to the junior_consultants list" do
      junior_consultant = FactoryGirl.create(:junior_consultant)
      delete :destroy, {:id => junior_consultant.to_param}, valid_session
      response.should redirect_to(junior_consultants_url)
    end
  end

end
