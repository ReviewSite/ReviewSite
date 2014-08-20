class ConsultingSkills < SitePrism::Section

	element :went_well, "#feedback_consulting_skills_went_well"
	element :to_be_improved, '#feedback_consulting_skills_to_be_improved'
	element :scale, '#feedback_consulting_skills_scale'
	element :save_button, '#review_consulting_skills + div > input.btn'

end