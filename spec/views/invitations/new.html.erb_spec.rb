require 'spec_helper'

describe "invitations/new" do
  let (:jc) { FactoryGirl.create(:junior_consultant) }
  let (:review) { FactoryGirl.create(:review, junior_consultant: jc, feedback_deadline: Date.today) }

  describe "rendering invitation form" do
    before { @review = review }

    subject do
      render
      rendered
    end

    it { should =~ /To:/ }
    it { should =~ /You've been invited to give feedback/ }
    it { should =~ /Body:/ }
    it { should =~ /#{jc.name}/ }
    it { should =~ /#{review.review_type}/ }
    it { should =~ /#{review.feedback_deadline}/ }
    it { should =~ /#{new_review_feedback_url(review)}/ }
  end
end