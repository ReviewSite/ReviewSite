require_relative 'project_details'
require_relative 'feedback_section'

class EditFeedbackPO < SitePrism::Page

	set_url "/reviews{/review_id}/feedbacks{/feedback_id}/"
	set_url_matcher /\/reviews\/\d+\/feedbacks\/\d+/

	section :project_details, ProjectDetails, '#span3'
	section :feedback_section, FeedbackSection, "#accordion"

	element :save_feedback, '.actions input:first'
	element :submit_final_button, "input[value='Submit Final']"
	element :cancel_button, '.actions a'


	def inputs
		{
		    # 'feedback_project_worked_on' => 'My Project',
		    # 'feedback_role_description' => 'My Role',
		    # 'feedback_tech_exceeded' => 'Input 1',
		    # 'feedback_tech_met' => 'Input 2',
		    # 'feedback_tech_improve' => 'Input 3',
		    # The rest of these are not visible (hidden in the accordion)
		    # 'feedback_client_exceeded' => 'Input 4',
		    # 'feedback_client_met' => 'Input 5',
		    # 'feedback_client_improve' => 'Input 6',
		    # 'feedback_ownership_exceeded' => 'Input 7',
		    # 'feedback_ownership_met' => 'Input 8',
		    # 'feedback_ownership_improve' => 'Input 9',
		    # 'feedback_leadership_exceeded' => 'Input 10',
		    # 'feedback_leadership_met' => 'Input 11',
		    # 'feedback_leadership_improve' => 'Input 12',
		    # 'feedback_teamwork_exceeded' => 'Input 13',
		    # 'feedback_teamwork_met' => 'Input 14',
		    # 'feedback_teamwork_improve' => 'Input 15',
		    # 'feedback_attitude_exceeded' => 'Input 16',
		    # 'feedback_attitude_met' => 'Input 17',
		    # 'feedback_attitude_improve' => 'Input 18',
		    # 'feedback_professionalism_exceeded' => 'Input 19',
		    # 'feedback_professionalism_met' => 'Input 20',
		    # 'feedback_professionalism_improve' => 'Input 21',
		    # 'feedback_organizational_exceeded' => 'Input 22',
		    # 'feedback_organizational_met' => 'Input 23',
		    # 'feedback_organizational_improve' => 'Input 24',
		    # 'feedback_innovative_exceeded' => 'Input 25',
		    # 'feedback_innovative_met' => 'Input 26',
		    # 'feedback_innovative_improve' => 'Input 27',
    		'feedback_comments' => 'My Comments'
  		}
	end

end