class CreateInvitationsForExistingFeedbacks < ActiveRecord::Migration
  def up
  	Feedback.all.each do |feedback|
  		unless feedback.invitation
  			feedback.review.invitations.create(email: feedback.user.email)
  		end
  	end
  end

  def down
  end
end
