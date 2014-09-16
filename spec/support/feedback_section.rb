require_relative 'role_competence_section'
require_relative 'consulting_skills_section'
require_relative 'teamwork_section'
require_relative 'contributions_section'
require_relative 'comments_section'

class FeedbackSection < SitePrism::Section

	section :role_competence, RoleCompetence, '#review_role_competence + div'
	section :consulting_skills, ConsultingSkills, '#review_consulting_skills + div'
	section :teamwork, Teamwork, '#review_teamwork + div'
	section :contributions, Contributions, '#review_conributions + div'
	section :comments, Comments, '#review_general_comments + div'

end