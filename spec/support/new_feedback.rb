require_relative 'project_details'
require_relative 'role_competence_section'
require_relative 'consulting_skills_section'
require_relative 'teamwork_section'
require_relative 'contributions_section'
require_relative 'comments_section'



class NewFeedbackPO < SitePrism::Page

	set_url "/reviews{/review_id}/feedbacks/new"
	set_url_matcher /\/reviews\/\d+\/feedbacks\/new/

	section :project_details, ProjectDetails, '.span3'
	section :role_competence, RoleCompetence, '#review_role_competence + div'
	section :consulting_skills, ConsultingSkills, '#review_consulting_skills + div'
	section :teamwork, Teamwork, '#review_teamwork + div'
	section :contributions, Contributions, '#review_conributions + div'
	section :comments, Comments, '#review_general_comments + div'

	elements :headers, 'h3'

	element :role_competence_header, 'h3#review_role_competence'
	element :consulting_skills_header, 'h3#review_consulting_skills'
	element :teamwork_header, 'h3#review_teamwork'
	element :contributions_header, 'h3#review_contributions'
	element :comments_header, 'h3#review_general_comments'
	element :save_feedback_button, '#save_feedback'
	element :submit_final_button, "#submit_final"
	element :cancel_button, '.actions a'


	def inputs
		{
		    # # 'feedback_project_worked_on' => 'My Project',
		    # # 'feedback_role_description' => 'My Role',
		    # # 'feedback_tech_exceeded' => 'Input 1',
		    # # 'feedback_tech_met' => 'Input 2',
		    # # 'feedback_tech_improve' => 'Input 3',
		    # # The rest of these are not visible (hidden in the accordion)
		    # # 'feedback_client_exceeded' => 'Input 4',
		    # # 'feedback_client_met' => 'Input 5',
		    # # 'feedback_client_improve' => 'Input 6',
		    # # 'feedback_ownership_exceeded' => 'Input 7',
		    # # 'feedback_ownership_met' => 'Input 8',
		    # # 'feedback_ownership_improve' => 'Input 9',
		    # # 'feedback_leadership_exceeded' => 'Input 10',
		    # # 'feedback_leadership_met' => 'Input 11',
		    # # 'feedback_leadership_improve' => 'Input 12',
		    # # 'feedback_teamwork_exceeded' => 'Input 13',
		    # # 'feedback_teamwork_met' => 'Input 14',
		    # # 'feedback_teamwork_improve' => 'Input 15',
		    # # 'feedback_attitude_exceeded' => 'Input 16',
		    # # 'feedback_attitude_met' => 'Input 17',
		    # # 'feedback_attitude_improve' => 'Input 18',
		    # # 'feedback_professionalism_exceeded' => 'Input 19',
		    # # 'feedback_professionalism_met' => 'Input 20',
		    # # 'feedback_professionalism_improve' => 'Input 21',
		    # # 'feedback_organizational_exceeded' => 'Input 22',
		    # # 'feedback_organizational_met' => 'Input 23',
		    # # 'feedback_organizational_improve' => 'Input 24',
		    # # 'feedback_innovative_exceeded' => 'Input 25',
		    # # 'feedback_innovative_met' => 'Input 26',
		    # # 'feedback_innovative_improve' => 'Input 27',
    		# 'feedback_comments' => 'My Comments'

			role_competence_header => {
				"feedback_role_competence_went_well" => "Input1",
				"feedback_role_competence_to_be_improved" => "Input2"
			},
			consulting_skills_header => {
				"feedback_consulting_skills_went_well" => "Input3",
				"feedback_consulting_skills_to_be_improved" => "Input4"
			},
			teamwork_header => {
				"feedback_teamwork_went_well" => "Input5",
				"feedback_teamwork_to_be_improved" => "Input6"
			},
			contributions_header => {
				"feedback_contributions_went_well" => "Input7",
				"feedback_contributions_to_be_improved" => "Input8"
			},
			comments_header => {
				"feedback_comments" => "Input9"
			}
		}
	end

end








