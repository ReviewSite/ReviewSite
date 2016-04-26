require 'spec_helper'

class ApplicationControllerSubclass < ApplicationController; end

describe ApplicationControllerSubclass do
  describe "email sent for unsubmitted feedback" do
    it "should return true for feedback that has not been submitted yet" do
      @feedback = create(:feedback)
      thing = email_sent_for_unsubmitted_feedback(@feedback)
      expect(thing).should be_true
    end
  end

end