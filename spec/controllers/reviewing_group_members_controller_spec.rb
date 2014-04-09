require 'spec_helper'

describe ReviewingGroupMembersController do
  before(:each) do
    @admin = FactoryGirl.create(:admin_user)
    set_current_user @admin
    @rg = FactoryGirl.create(:reviewing_group)
    @user = FactoryGirl.create(:user)
  end

  def valid_attributes
    {
      reviewing_group_id: @rg.id,
      user_id: @user.id
    }
  end

  def valid_session
    {userinfo: "test@test.com"}
  end

  describe "GET index" do
    it "assigns all reviewing_group_members as @reviewing_group_members" do
      reviewing_group_member = ReviewingGroupMember.create! valid_attributes
      get :index, {}, valid_session
      assigns(:reviewing_group_members).should eq([reviewing_group_member])
    end
  end

  describe "GET new" do
    it "assigns a new reviewing_group_member as @reviewing_group_member" do
      get :new, {}, valid_session
      assigns(:reviewing_group_member).should be_a_new(ReviewingGroupMember)
    end
  end

  describe "GET edit" do
    it "assigns the requested reviewing_group_member as @reviewing_group_member" do
      reviewing_group_member = ReviewingGroupMember.create! valid_attributes
      get :edit, {:id => reviewing_group_member.to_param}, valid_session
      assigns(:reviewing_group_member).should eq(reviewing_group_member)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new ReviewingGroupMember" do
        expect {
          post :create, {:reviewing_group_member => valid_attributes}, valid_session
        }.to change(ReviewingGroupMember, :count).by(1)
      end

      it "assigns a newly created reviewing_group_member as @reviewing_group_member" do
        post :create, {:reviewing_group_member => valid_attributes}, valid_session
        assigns(:reviewing_group_member).should be_a(ReviewingGroupMember)
        assigns(:reviewing_group_member).should be_persisted
      end

      it "redirects to the created reviewing_group_member" do
        post :create, {:reviewing_group_member => valid_attributes}, valid_session
        response.should redirect_to(reviewing_group_members_path)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved reviewing_group_member as @reviewing_group_member" do
        # Trigger the behavior that occurs when invalid params are submitted
        ReviewingGroupMember.any_instance.stub(:save).and_return(false)
        post :create, {:reviewing_group_member => {}}, valid_session
        assigns(:reviewing_group_member).should be_a_new(ReviewingGroupMember)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        ReviewingGroupMember.any_instance.stub(:save).and_return(false)
        post :create, {:reviewing_group_member => {}}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested reviewing_group_member" do
        reviewing_group_member = ReviewingGroupMember.create! valid_attributes
        # Assuming there are no other reviewing_group_members in the database, this
        # specifies that the ReviewingGroupMember created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        ReviewingGroupMember.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => reviewing_group_member.to_param, :reviewing_group_member => {'these' => 'params'}}, valid_session
      end

      it "assigns the requested reviewing_group_member as @reviewing_group_member" do
        reviewing_group_member = ReviewingGroupMember.create! valid_attributes
        put :update, {:id => reviewing_group_member.to_param, :reviewing_group_member => valid_attributes}, valid_session
        assigns(:reviewing_group_member).should eq(reviewing_group_member)
      end

      it "redirects to the reviewing_group_member" do
        reviewing_group_member = ReviewingGroupMember.create! valid_attributes
        put :update, {:id => reviewing_group_member.to_param, :reviewing_group_member => valid_attributes}, valid_session
        response.should redirect_to(reviewing_group_members_path)
      end
    end

    describe "with invalid params" do
      it "assigns the reviewing_group_member as @reviewing_group_member" do
        reviewing_group_member = ReviewingGroupMember.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ReviewingGroupMember.any_instance.stub(:save).and_return(false)
        put :update, {:id => reviewing_group_member.to_param, :reviewing_group_member => {}}, valid_session
        assigns(:reviewing_group_member).should eq(reviewing_group_member)
      end

      it "re-renders the 'edit' template" do
        reviewing_group_member = ReviewingGroupMember.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        ReviewingGroupMember.any_instance.stub(:save).and_return(false)
        put :update, {:id => reviewing_group_member.to_param, :reviewing_group_member => {}}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested reviewing_group_member" do
      reviewing_group_member = ReviewingGroupMember.create! valid_attributes
      expect {
        delete :destroy, {:id => reviewing_group_member.to_param}, valid_session
      }.to change(ReviewingGroupMember, :count).by(-1)
    end

    it "redirects to the reviewing_group_members list" do
      reviewing_group_member = ReviewingGroupMember.create! valid_attributes
      delete :destroy, {:id => reviewing_group_member.to_param}, valid_session
      response.should redirect_to(reviewing_group_members_url)
    end
  end

end
