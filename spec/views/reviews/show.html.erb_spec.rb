require 'spec_helper'

describe "reviews/show" do
  before(:each) do
    @review = FactoryGirl.create(:review)
    @user1 = FactoryGirl.create(:user, :name => "Bob")
    @user2 = FactoryGirl.create(:user, :name => "Jane")
    @feedback1 = FactoryGirl.create(:submitted_feedback, :review => @review, :user => @user1, :project_worked_on => "First Project")
    @feedback2 = FactoryGirl.create(:submitted_feedback, :review => @review, :user => @user2, :project_worked_on => "Second Project")

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end

  it "renders details of the review" do
    render
    rendered.should match(/#{@review.junior_consultant.user}/)
    rendered.should match(/#{@review.review_type.titleize}/)
  end
  it "renders feedbacks' user names" do
    render
    rendered.should match(/Bob/)
    rendered.should match(/Jane/)
  end
  it "renders feedbacks' project names" do
    render
    rendered.should match(/First Project/)
    rendered.should match(/Second Project/)
  end
end
