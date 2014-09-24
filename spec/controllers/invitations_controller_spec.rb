require 'spec_helper'

describe InvitationsController do
  let (:admin) { FactoryGirl.create(:admin_user) }
  let (:review) { FactoryGirl.create(:review, feedback_deadline: Date.today) }

  before { set_current_user admin }

  def valid_sessions
    {userinfo: "test@test.com"}
  end

  describe "POST create" do
    describe "with valid record" do
      it "saves the record" do
        post :create, {username: "test", review_id: review.id}, valid_sessions
        Invitation.last.email.should == "test@thoughtworks.com"
      end

      it "sends an email with correct details" do
        ActionMailer::Base.deliveries.clear
        post :create, {username: "test", review_id: review.id, message: "This is the custom message"}, valid_sessions
        num_deliveries = ActionMailer::Base.deliveries.size
        num_deliveries.should == 1 # one for error
        message = ActionMailer::Base.deliveries.first
        message.to.should == ["test@thoughtworks.com"]
        message.body.encoded.should match("This is the custom message")
      end

      it "doesn't send an email if params[:no_email] is passed" do
        ActionMailer::Base.deliveries.clear
        post :create, {username: "test", review_id: review.id, no_email: '1'}, valid_sessions
        ActionMailer::Base.deliveries.should == []
      end

      it "redirects to the homepage" do
        post :create, {username: "test", review_id: review.id}, valid_sessions
        response.should redirect_to(root_path)
      end

      it "flashes a notification" do
        post :create, {username: "test", review_id: review.id}, valid_sessions
        flash[:success].should == "An invitation has been sent!"
      end
    end

    describe "with invalid record" do
      it "does not save the record" do
        expect do
          post :create, {username: "!!!invalid!!!", review_id: review.id}, valid_sessions
        end.to change(Invitation, :count).by(0)
      end

      it "does not send an email" do
        UserMailer.should_not_receive(:review_invitation)
        post :create, {username: "!!!invalid!!!", review_id: review.id}, valid_sessions
      end

      it "renders new" do
        post :create, {username: "!!!invalid!!!", review_id: review.id}, valid_sessions
        response.should render_template("new")
        assigns(:ac).should == review.associate_consultant
      end
    end

    describe "if invited user has already created feedback" do
      let (:reviewer) { FactoryGirl.create(:user, email: "test@thoughtworks.com") }
      let!(:feedback) { FactoryGirl.create(:feedback, review: review, user: reviewer) }

      it "does not save the record" do
        expect do
          post :create, {username: "test", review_id: review.id}, valid_sessions
        end.to change(Invitation, :count).by(0)
      end

      it "does not send an email" do
        UserMailer.should_not_receive(:review_invitation)
        post :create, {username: "test", review_id: review.id}, valid_sessions
      end

      it "renders new" do
        post :create, {username: "test", review_id: review.id}, valid_sessions
        flash[:notice].should == "This person has already created feedback for this review."
        response.should render_template("new")
        assigns(:ac).should == review.associate_consultant
      end
    end
  end

  describe "DELETE destroy" do
    let! (:invitation) { review.invitations.create!(email: "test@example.com") }
    it "destroys the requested invitation" do
      expect do
        delete :destroy, {id: invitation.to_param, review_id: review.id}, valid_sessions
      end.to change(Invitation, :count).by(-1)
    end

    it "redirects to the homepage" do
      delete :destroy, {id: invitation.to_param, review_id: review.id}, valid_sessions
      response.should redirect_to(root_path)
    end

    it "flashes a notification" do
      delete :destroy, {id: invitation.to_param, review_id: review.id}, valid_sessions
      flash[:notice].should == "Invitation has been deleted"
    end
  end

  describe "POST send_reminder" do
    let! (:invitation) { review.invitations.create!(email: "test@example.com") }

    describe "with submitted feedback" do
      let (:reviewer) { FactoryGirl.create(:user, email: "test@example.com") }
      let! (:feedback) { FactoryGirl.create(:submitted_feedback, review: review, user: reviewer) }

      it "redirects to the homepage" do
        post :send_reminder, {id: invitation.to_param, review_id: review.id}, valid_sessions
        response.should redirect_to(root_path)
      end

      it "notifies that email has not been sent" do
        post :send_reminder, {id: invitation.to_param, review_id: review.id}, valid_sessions
        flash[:alert].should == "Feedback already submitted. Reminder not sent."
      end

      it "does not send an email" do
        expect do
          post :send_reminder, {id: invitation.to_param, review_id: review.id}, valid_sessions
        end.to change{ ActionMailer::Base.deliveries.length }.by(0)
      end
    end

    describe "without submitted feedback" do
      let (:reviewer) { FactoryGirl.create(:user, email: "test@example.com") }
      let! (:feedback) { FactoryGirl.create(:feedback, review: review, user: reviewer) }

      it "redirects to the homepage" do
        post :send_reminder, {id: invitation.to_param, review_id: review.id}, valid_sessions
        response.should redirect_to(root_path)
      end

      it "notifies that email has been sent" do
        post :send_reminder, {id: invitation.to_param, review_id: review.id}, valid_sessions
        flash[:success].should == "Reminder email was sent!"
      end

      it "delivers an email with the correct content" do
        ActionMailer::Base.deliveries.clear
        post :send_reminder, {id: invitation.to_param, review_id: review.id}, valid_sessions
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
