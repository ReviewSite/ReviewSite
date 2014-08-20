class FeedbackShowPO < SitePrism::Page

	set_url "/reviews{/review_id}/feedbacks{/feedback_id}"

	elements :review_values, '#review span'

end