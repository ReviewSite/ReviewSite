require 'spec_helper'

describe ReviewingGroupsController do
  before(:each) do
    @admin_user = FactoryGirl.create(:admin_user)
    set_current_user(@admin_user)
  end

  def valid_attributes
    { name: 'Chicago'
    }
  end

  def valid_session
    {:userinfo => "test@test.com"}
  end

  describe "GET index" do
    it "assigns all reviewing_groups as @reviewing_groups" do
      reviewing_group = ReviewingGroup.create! valid_attributes
      get :index, {}, valid_session
      assigns(:reviewing_groups).should eq([reviewing_group])
    end
  end

  describe "GET new" do
    it "assigns a new reviewing_group as @reviewing_group" do
      get :new, {}, valid_session
      assigns(:reviewing_group).should be_a_new(ReviewingGroup)
    end
  end

  describe "GET edit" do
    it "assigns the requested reviewing_group as @reviewing_group" do
      reviewing_group = ReviewingGroup.create! valid_attributes
      get :edit, {:id => reviewing_group.to_param}, valid_session
      assigns(:reviewing_group).should eq(reviewing_group)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ReviewingGroup" do
        expect {
          post :create, {:reviewing_group => valid_attributes}, valid_session
        }.to change(ReviewingGroup, :count).by(1)
      end

      it "assigns a newly created reviewing_group as @reviewing_group" do
        post :create, {:reviewing_group => valid_attributes}, valid_session
        assigns(:reviewing_group).should be_a(ReviewingGroup)
        assigns(:reviewing_group).should be_persisted
      end

      it "redirects to the reviewing_groups list" do
        post :create, {:reviewing_group => valid_attributes}, valid_session
        response.should redirect_to(reviewing_groups_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved reviewing_group as @reviewing_group" do
        # Trigger the behavior that occurs when invalid params are submitted
        ReviewingGroup.any_instance.stub(:save).and_return(false)
        post :create, {:reviewing_group => {}}, valid_session
        assigns(:reviewing_group).should be_a_new(ReviewingGroup)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ReviewingGroup.any_instance.stub(:save).and_return(false)
        post :create, {:reviewing_group => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested reviewing_group" do
        reviewing_group = ReviewingGroup.create! valid_attributes
        # Assuming there are no other reviewing_groups in the database, this
        # specifies that the ReviewingGroup created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ReviewingGroup.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => reviewing_group.to_param, :reviewing_group => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested reviewing_group as @reviewing_group" do
        reviewing_group = ReviewingGroup.create! valid_attributes
        put :update, {:id => reviewing_group.to_param, :reviewing_group => valid_attributes}, valid_session
        assigns(:reviewing_group).should eq(reviewing_group)
      end

      it "redirects to the reviewing_group" do
        reviewing_group = ReviewingGroup.create! valid_attributes
        put :update, {:id => reviewing_group.to_param, :reviewing_group => valid_attributes}, valid_session
        response.should redirect_to(reviewing_groups_url)
      end
    end

    describe "with invalid params" do
      it "assigns the reviewing_group as @reviewing_group" do
        reviewing_group = ReviewingGroup.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ReviewingGroup.any_instance.stub(:save).and_return(false)
        put :update, {:id => reviewing_group.to_param, :reviewing_group => {}}, valid_session
        assigns(:reviewing_group).should eq(reviewing_group)
      end

      it "re-renders the 'edit' template" do
        reviewing_group = ReviewingGroup.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ReviewingGroup.any_instance.stub(:save).and_return(false)
        put :update, {:id => reviewing_group.to_param, :reviewing_group => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested reviewing_group" do
      reviewing_group = ReviewingGroup.create! valid_attributes
      expect {
        delete :destroy, {:id => reviewing_group.to_param}, valid_session
      }.to change(ReviewingGroup, :count).by(-1)
    end

    it "redirects to the reviewing_groups list" do
      reviewing_group = ReviewingGroup.create! valid_attributes
      delete :destroy, {:id => reviewing_group.to_param}, valid_session
      response.should redirect_to(reviewing_groups_url)
    end
  end

end
