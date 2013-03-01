require 'spec_helper'

describe "Authentication pages" do
  subject { page }

  describe "forgotten password" do
    before do
      visit signin_path
      click_link "Forgot password"
    end

    it { should have_selector('title', text:'Reset password') }
  end
end