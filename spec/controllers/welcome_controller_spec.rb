require 'spec_helper'

describe WelcomeController do

  describe "#index" do
    before do
      get :index
    end
    it { should assign_to(:reviews) }
    it { should assign_to(:feedbacks) }
  end

end
