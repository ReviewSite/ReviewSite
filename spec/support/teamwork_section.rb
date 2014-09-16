class Teamwork < SitePrism::Section

	element :went_well, "#feedback_teamwork_went_well"
	element :to_be_improved, '#feedback_teamwork_to_be_improved'
	element :scale, '#feedback_teamwork_scale'
	element :save_button, '#review_teamwork + div > input.btn'

end