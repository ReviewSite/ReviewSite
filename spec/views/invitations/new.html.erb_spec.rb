require 'spec_helper'

describe "invitations/new" do
  describe "rendering invitation form" do
    before do
      @ac = FactoryGirl.create(:associate_consultant)
      @review = FactoryGirl.create(:review, associate_consultant: @ac, feedback_deadline: Date.today)
      @invitation = FactoryGirl.build(:invitation)
    end

    subject do
      render
      rendered
    end

    it { should =~ /To:/ }
    it { should =~ /Body \(Please add a personal note\):/ }
    it { should =~ /#{@ac.user.name}/ }
    it { should =~ /#{@review.review_type}/ }
    it { should =~ /#{@review.feedback_deadline}/ }
    it { should =~ /#{new_review_feedback_url(@review)}/ }
  end
end
