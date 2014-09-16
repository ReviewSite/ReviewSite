class RoleCompetence < SitePrism::Section

	element :went_well, "#feedback_role_competence_went_well"
	element :to_be_improved, '#feedback_role_competence_to_be_improved'
	element :scale, '#feedback_role_competence_scale'
	element :save_button, '#review_role_competence + div > input.btn'

end