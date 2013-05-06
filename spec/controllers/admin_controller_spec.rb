require 'spec_helper'

describe AdminController do
  describe "#index" do
    describe 'as an admin user' do
      before do
        set_current_user FactoryGirl.create(:admin_user)
      end

      it 'should list all the reviews' do
        review_one = FactoryGirl.build(:review)
        review_two = FactoryGirl.build(:review)
        Review.stub(:all).and_return([review_one, review_two])

        get :index

        assigns(:reviews).should =~ [review_one, review_two]
      end

      it 'should list all the feedbacks' do
        feedback_one = FactoryGirl.build(:feedback)
        feedback_two = FactoryGirl.build(:feedback)
        Feedback.stub(:all).and_return([feedback_one, feedback_two])

        get :index

        assigns(:feedbacks).should =~ [feedback_one, feedback_two]
      end
    end

    describe 'as a regular user' do
      before do
        set_current_user FactoryGirl.create(:user)
      end

      it 'should redirect to home' do
        get :index

        response.should redirect_to root_path
      end
    end
  end
end
