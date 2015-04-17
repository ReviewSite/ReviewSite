require 'spec_helper'

describe InvitationsController do
  let (:user) { create(:user) }
  let (:associate_consultant) { create(:associate_consultant, user: user)}
  let (:review) { create(:review, feedback_deadline: Date.today, associate_consultant: associate_consultant) }

  before { set_current_user user }

  def valid_sessions
    {userinfo: "test@test.com"}
  end

  describe "POST create" do
    describe "with valid record" do
      it "saves the record" do
        post :create, {emails: "test@thoughtworks.com", review_id: review.id}, valid_sessions
        Invitation.last.email.should == "test@thoughtworks.com"
      end

      it "saves the record with multiple emails" do
        post :create, {emails: "test@thoughtworks.com, test2@thoughtworks.com", review_id: review.id}, valid_sessions
        Invitation.last(2)[0].email.should == "test@thoughtworks.com"
        Invitation.last(2)[1].email.should == "test2@thoughtworks.com"
      end

      it "sends an email with correct details" do
        ActionMailer::Base.deliveries.clear
        post :create, {emails: "test@thoughtworks.com", review_id: review.id, message: "This is the custom message"}, valid_sessions
        num_deliveries = ActionMailer::Base.deliveries.size
        num_deliveries.should == 1 # one for error
        message = ActionMailer::Base.deliveries.first
        message.to.should == ["test@thoughtworks.com"]
        message.body.encoded.should match("This is the custom message")
      end


      it "doesn't send an email if params[:no_email] is passed" do
        ActionMailer::Base.deliveries.clear
        post :create, {emails: "test@thoughtworks.com", review_id: review.id, no_email: '1'}, valid_sessions
        ActionMailer::Base.deliveries.should == []
      end

      it "redirects to the review" do
        post :create, {emails: "test@thoughtworks.com", review_id: review.id}, valid_sessions
        response.should redirect_to(review)
      end

      it "flashes a notification" do
        post :create, {emails: "test@thoughtworks.com", review_id: review.id}, valid_sessions
        flash[:success].should == "An invitation has been sent to: test@thoughtworks.com"
      end

      it "flashes a notification for multiple valid emails" do
        post :create, {emails: "test@thoughtworks.com, test2@thoughtworks.com", review_id: review.id}, valid_sessions
        flash[:success].should include("An invitation has been sent to: ")
        flash[:success].should include("test@thoughtworks.com")
        flash[:success].should include("test2@thoughtworks.com")
      end
    end

    describe "with invalid record" do
      it "does not save the record" do
        expect do
          post :create, {emails: "!!!invalid!!!", review_id: review.id}, valid_sessions
        end.to change(Invitation, :count).by(0)
      end

      it "does not send an email" do
        UserMailer.should_not_receive(:review_invitation)
        post :create, {emails: "!!!invalid!!!", review_id: review.id}, valid_sessions
      end

      it "renders new" do
        post :create, {emails: "!!!invalid!!!", review_id: review.id}, valid_sessions
        response.should render_template("new")
        assigns(:ac).should == review.associate_consultant
      end

      it "with one valid email displays error messages" do
        post :create, {emails: "test@thoughtworks.com, !!!invalid!!!", review_id: review.id}, valid_sessions
        flash[:success].should == "An invitation has been sent to: test@thoughtworks.com"
        flash[:alert].should include("!!!invalid!!! could not be invited -- Invalid Email.")
      end

      it "with multiple emails with errors displays multiple error messages" do
        post :create, {emails: "!!!invalid1!!!, !!!invalid2!!!", review_id: review.id}, valid_sessions
        flash[:alert].should include("!!!invalid1!!! could not be invited -- Invalid Email.")
        flash[:alert].should include("!!!invalid2!!! could not be invited -- Invalid Email.")
      end

      it "with one valid email saves the valid one" do
        expect do
          post :create, {emails: "test@thoughtworks.com, !!!invalid!!!", review_id: review.id}, valid_sessions
        end.to change(Invitation, :count).by(1)
        Invitation.last.email.should == "test@thoughtworks.com"
      end

      it "with one valid email renders new" do
        post :create, {emails: "test@thoughtworks.com, !!!invalid!!!", review_id: review.id}, valid_sessions
        response.should render_template("new")
        assigns(:ac).should == review.associate_consultant
      end

      it "rejects non-thoughtworks email" do
        post :create, {emails: "test@thoughtworks.com, nontw@gmail.com", review_id: review.id}, valid_sessions
        flash[:alert].should include("nontw@gmail.com could not be invited -- Not a ThoughtWorks Email.")
      end

      it "rejects improper email format" do
        post :create, {emails: "testthoughtworks.com", review_id: review.id}, valid_sessions
        flash[:alert].should include("testthoughtworks.com could not be invited -- Invalid Email.")
      end

      it "rejects already invited user" do
        create(:invitation, email: "test@thoughtworks.com", review: review)
        post :create, {emails: "test@thoughtworks.com", review_id: review.id}, valid_sessions
        flash[:alert].should include("test@thoughtworks.com could not be invited -- Email already invited.")
      end
    end

    describe "if invited user has already created feedback" do
      let (:reviewer) { create(:user, email: "test@thoughtworks.com") }
      let!(:feedback) { create(:feedback, review: review, user: reviewer) }

      it "does not save the record" do
        expect do
          post :create, {emails: "test@thoughtworks.com", review_id: review.id}, valid_sessions
        end.to change(Invitation, :count).by(0)
      end

      it "does not send an email" do
        UserMailer.should_not_receive(:review_invitation)
        post :create, {emails: "test@thoughtworks.com", review_id: review.id}, valid_sessions
      end

      it "renders new" do
        post :create, {emails: "test@thoughtworks.com", review_id: review.id}, valid_sessions
        flash[:alert].should include("test@thoughtworks.com has already given feedback for this review.")
        response.should render_template("new")
        assigns(:ac).should == review.associate_consultant
      end
    end
  end

  describe "DELETE destroy" do
    let! (:invitation) { review.invitations.create!(email: "test@thoughtworks.com") }
    let (:reviewer) { create(:user, email: "test@thoughtworks.com") }

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
      flash[:success].should == "#{invitation.email}\'s invitation has been deleted."
    end

    it "flashes different notification on decline" do
      set_current_user reviewer
      delete :destroy, {id: invitation.to_param, review_id: review.id}, valid_sessions
      flash[:success].should == "You have successfully declined #{review.reviewee}\'s feedback request."
      set_current_user user
    end

    it "send a notification email when reviewee deletes invitation" do
      set_current_user reviewer

      message = double(Mail::Message)
      message.should_receive(:deliver)
      UserMailer.stub!(:feedback_declined).and_return(message)
      UserMailer.should_receive(:feedback_declined).with(invitation)

      delete :destroy, {id: invitation.to_param, review_id: review.id}, valid_sessions

      set_current_user user
    end

    it "otherwise does not send notification email" do
      UserMailer.should_not_receive(:feedback_declined).with(invitation)

      delete :destroy, {id: invitation.to_param, review_id: review.id}, valid_sessions
    end
  end

  describe "POST send_reminder" do
    let! (:invitation) { review.invitations.create!(email: "test@thoughtworks.com") }

    describe "with submitted feedback" do
      let (:reviewer) { create(:user, email: "test@thoughtworks.com") }
      let! (:feedback) { create(:submitted_feedback, review: review, user: reviewer) }

      it "redirects to the review" do
        post :send_reminder, {id: invitation.to_param, review_id: review.id}, valid_sessions
        response.should redirect_to(review)
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
      let (:reviewer) { create(:user, email: "test@thoughtworks.com") }
      let! (:feedback) { create(:feedback, review: review, user: reviewer) }

      it "redirects to the review" do
        post :send_reminder, {id: invitation.to_param, review_id: review.id}, valid_sessions
        response.should redirect_to(review)
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
        message.to.should == ["test@thoughtworks.com"]
        message.body.encoded.should match(
          "You have saved feedback, but it has not yet been submitted. To continue working, please visit"
        )
      end
    end
  end
end
