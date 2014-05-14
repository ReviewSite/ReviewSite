require 'spec_helper'
require 'cancan/matchers'
describe Ability do
  describe "Admin" do
    before do
      @admin_user = FactoryGirl.create(:admin_user)
      @ability = Ability.new(@admin_user)
    end
    subject{@ability}
    it{ should be_able_to(:manage, Review) }
    it{ should be_able_to(:manage, ReviewingGroup) }
    it{ should be_able_to(:manage, JuniorConsultant) }
    it{ should be_able_to(:manage, User) }
    it{ should be_able_to(:manage, SelfAssessment) }
    it{ should be_able_to(:submit, Feedback) }
    it{ should be_able_to(:unsubmit, Feedback) }
    it{ should be_able_to(:summary, Review) }
    it{ should be_able_to(:read, Feedback) }
    it{ should be_able_to(:update, User)}
  end

  describe "User" do
    before do
      @user = FactoryGirl.create(:user)
      @ability = Ability.new(@user)
    end
    subject{@ability}
    it{ should_not be_able_to(:manage, Review) }
    it{ should_not be_able_to(:manage, ReviewingGroup) }
    it{ should_not be_able_to(:manage, JuniorConsultant) }
    it{ should_not be_able_to(:manage, User) }
    it{ should be_able_to(:manage, SelfAssessment) }
    it{ should_not be_able_to(:submit, Feedback) }
    it{ should_not be_able_to(:unsubmit, Feedback) }
    it{ should be_able_to(:summary, Review) }
    it{ should be_able_to(:read, Feedback) }
    it{ should be_able_to(:update, User)}
  end

end
