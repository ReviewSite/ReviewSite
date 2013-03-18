require 'spec_helper'

describe InvitationsController do
  let (:admin) { FactoryGirl.create(:admin_user) }
  let (:review) { FactoryGirl.create(:review) }

  before { sign_in admin }

  describe "POST create" do
    describe "with valid record" do
      it "saves the record" do
        post :create, email: "test@example.com", review_id: review.id
        Invitation.last.email.should == "test@example.com"
      end

      it "sends an email" do
        deliverable = double(deliver: true)
        deliverable.should_receive(:deliver)
        UserMailer.stub(review_invitation: deliverable)
        post :create, email: "test@example.com", review_id: review.id
      end

      it "redirects to the homepage" do
        post :create, email: "test@example.com", review_id: review.id
        response.should redirect_to(root_path)
      end

      it "flashes a notification" do
        post :create, email: "test@example.com", review_id: review.id
        flash[:notice].should == "An invitation has been sent!"
      end
    end

    describe "with invalid record" do
      it "does not save the record" do
        expect do
          post :create, email: "invalid email address", review_id: review.id
        end.to change(Invitation, :count).by(0)
      end

      it "does not send an email" do
        UserMailer.should_not_receive(:review_invitation)
        post :create, email: "invalid email address", review_id: review.id
      end

      it "renders new" do
        post :create, email: "invalid email address", review_id: review.id
        response.should render_template("new")
      end
    end
  end

  describe "DELETE destroy" do
    let! (:invitation) { review.invitations.create!(email: "test@example.com") }
    it "destroys the requested invitation" do
      expect do
        delete :destroy, id: invitation.to_param, review_id: review.id
      end.to change(Invitation, :count).by(-1)
    end

    it "redirects to the homepage" do
      delete :destroy, id: invitation.to_param, review_id: review.id
      response.should redirect_to(root_path)
    end

    it "flashes a notification" do
      delete :destroy, id: invitation.to_param, review_id: review.id
      flash[:notice].should == "Invitation has been deleted"
    end
  end
end