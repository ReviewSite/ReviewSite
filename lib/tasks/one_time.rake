
namespace :one_time do
	desc 'Assign existing feedback a reported by value'
  task :assign_feedback_reported_by => :environment do
    feedback_with_no_reporter = Feedback.where(reported_by: nil)
    feedback_with_no_reporter.map do |feedback|
      if feedback.user == feedback.review.reviewee
        feedback.update_column(:reported_by, Feedback::SELF_REPORTED)
      else
        feedback.update_column(:reported_by, Feedback::PEER_REPORTED)
      end
    end
  end
end