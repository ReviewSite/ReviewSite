require 'spec_helper'

describe InvitationsController do
  let (:admin) { FactoryGirl.create(:admin_user) }
  let (:review) { FactoryGirl.create(:review, feedback_deadline: Date.today) }

  before { sign_in admin }

  describe "POST create" do
    describe "with valid record" do
      it "saves the record" do
        post :create, email: "test@example.com", review_id: review.id
        Invitation.last.email.should == "test@example.com"
      end

      it "sends an email with correct details" do
        ActionMailer::Base.deliveries.clear
        post :create, email: "test@example.com", review_id: review.id, message: "This is the custom message"
        num_deliveries = ActionMailer::Base.deliveries.size
        num_deliveries.should == 1 # one for error
        message = ActionMailer::Base.deliveries.first
        message.to.should == ["test@example.com"]
        message.body.encoded.should match("This is the custom message")
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
        assigns(:jc).should == review.junior_consultant
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

  describe "POST send_reminder" do
    let! (:invitation) { review.invitations.create!(email: "test@example.com") }

    describe "with submitted feedback" do
      let (:reviewer) { FactoryGirl.create(:user, email: "test@example.com") }
      let! (:feedback) { FactoryGirl.create(:submitted_feedback, review: review, user: reviewer) }

      it "redirects to the homepage" do
        post :send_reminder, id: invitation.to_param, review_id: review.id
        response.should redirect_to(root_path)
      end

      it "notifies that email has not been sent" do
        post :send_reminder, id: invitation.to_param, review_id: review.id
        flash[:notice].should == "Feedback already submitted. Reminder not sent."
      end

      it "does not send an email" do
        expect do
          post :send_reminder, id: invitation.to_param, review_id: review.id
        end.to change{ ActionMailer::Base.deliveries.length }.by(0)
      end
    end

    describe "without submitted feedback" do
      let (:reviewer) { FactoryGirl.create(:user, email: "test@example.com") }
      let! (:feedback) { FactoryGirl.create(:feedback, review: review, user: reviewer) }

      it "redirects to the homepage" do
        post :send_reminder, id: invitation.to_param, review_id: review.id
        response.should redirect_to(root_path)
      end

      it "notifies that email has been sent" do
        post :send_reminder, id: invitation.to_param, review_id: review.id
        flash[:notice].should == "Reminder email was sent!"
      end

      it "delivers an email with the correct content" do
        ActionMailer::Base.deliveries.clear
        post :send_reminder, id: invitation.to_param, review_id: review.id
        num_deliveries = ActionMailer::Base.deliveries.size
        num_deliveries.should == 1
        message = ActionMailer::Base.deliveries.first
        message.to.should == ["test@example.com"]
        message.body.encoded.should match(
          "You have saved feedback, but it has not yet been submitted. To continue working, please visit"
        )
      end
    end      
  end
end
