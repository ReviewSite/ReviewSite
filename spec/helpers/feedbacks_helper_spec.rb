require 'spec_helper'

class Klass
  include FeedbacksHelper
end

describe FeedbacksHelper do
  describe '#open_requests' do
    let(:klass) { Klass.new }



    describe 'no unsubmitted feedback' do
      let(:user) { create(:user) }
      let(:invitations) { create_list(:invitation, 5, email: user.email) }

      it 'should return the count of invitations' do
        Invitation.stub(:where).with(anything()).and_return(invitations)
        klass.open_requests(user).should == 5
      end

      it 'should not include invitations that already have submitted feedback associated with them' do
        feedback = create(:submitted_feedback, user: user, review: invitations.first.review)
        klass.open_requests(user).should == 4
      end
    end

    describe 'no invitations' do
      let!(:feedback) { create(:feedback) }

      it 'should return the count of feedback' do
        Invitation.stub(:where).with(anything()).and_return([])
        klass.open_requests(feedback.user).should == 1
      end
    end
  end

  describe '#feedback_priorities' do
    let(:klass) { Klass.new }

    subject { klass.feedback_priorities }

    its(:first)  { should == ['1st', 1] }
    its(:second) { should == ['2nd', 2] }
    its(:third)  { should == ['3rd', 3] }
    its(:fourth) { should == ['4th', 4] }
  end
end