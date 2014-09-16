class Contributions < SitePrism::Section

	element :went_well, "#feedback_contributions_went_well"
	element :to_be_improved, '#feedback_contributions_to_be_improved'
	element :scale, '#feedback_contributions_scale'
	element :save_button, '#review_contributions + div > input.btn'

end