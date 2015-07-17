class QuestionBuilder
	def self.build(associate_consultant)
		questions = {}

		questions["Comments"] = Review::Question.new("Comments", " General Comments", ["project_worked_on", "role_description", "comments"],
										"<p>\
											<div class = \'ideaListHeader\'><b> Only have a minute? </b>\
											Quickly share your feedback for #{associate_consultant}, or click continue to provide in-depth commentary.</div>\
										</p>")

    questions["Role Competence"] = Review::Question.new("Role Competence", " Role Competence", ["role_competence_went_well", "role_competence_to_be_improved"],
                    "<p class = \'ideaList\'> \
                      <div class = \'ideaListHeader\'><b> Understanding:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> understand the tech stack and/or the business domain? </li>\
                        <li> have sufficient knowledge to help onboard new team members? </li></ul>\

                      <div class = \'ideaListHeader\'><b> Ownership of Concepts:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> act as a go-to person for a specific topic? </li>\
                        <li> take leadership in situations related to their specialities? </li>\
                        <li> teach others? </li></ul>\

                      <div class = \'ideaListHeader\'><b> Self Directed Learning:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> study project-related topics outside of work? </li>\
                        <li> apply lessons learned through studies to the project? </li>\
                        <li> look for and suggest new ways to improve the project? </li></ul>\
                    </p>")

    questions["Consulting Skills"] = Review::Question.new("Consulting Skills", " Consulting Skills", ["consulting_skills_went_well", "consulting_skills_to_be_improved"],
                    "<p class = \'ideaList\'> \
                      <div class = \'ideaListHeader\'><b> Client Relationships:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> understand the clients\' needs and deadlines? </li>\
                        <li> actively build relationships? </li>\
                        <li> push back when necessary and provide constructive reasons? </li></ul>\

                      <div class = \'ideaListHeader\'><b> Communication Skills\:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> ask questions and actively listen? </li>\
                        <li> contribute focused and effective ideas to discussions? </li>\
                        <li> offer concerns and alternative solutions? </li></ul>\

                      <div class = \'ideaListHeader\'><b> Professionalism:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> demonstrate accountability for assigned tasks and responsibilities? </li>\
                        <li> show up on time and work necessary hours? </li>\
                        <li> behave appropriately in work environments? </li>\
                        <li> follow through on commitments? </li>\
                        <li> show awareness of others\' perceptions? </li></ul>\
                    </p>")

    questions["Teamwork"] = Review::Question.new("Teamwork", " Teamwork", ["teamwork_went_well", "teamwork_to_be_improved"],
                    "<p class = \'ideaList\'>\
                      <div class = \'ideaListHeader\'><b> Attitude:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> show enthusiasm for the project? </li>\
                        <li> focus on helping the team succeed rather than having their own \'hero moments\'? </li></ul>\

                      <div class = \'ideaListHeader\'><b> Collaboration:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> communicate effectively and respectfully in one-on-one conversations? </li>\
                        <li> facilitate cross-role communication? </li>\
                        <li> resolve conflicts within the team? </li>\
                        <li> give and receive feedback well? </li></ul>\
                    </p>")

    questions["Contributions"] = Review::Question.new("Contributions", " Contributions", ["contributions_went_well", "contributions_to_be_improved"],
                    "<p class = \'ideaList\'>\
                      <div class = \'ideaListHeader\'><b> Knowledge Sharing:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> give presentations or lead discussions? </li>\
                        <li> reach out and offer support to other ThoughtWorkers? </li></ul>\

                      <div class = \'ideaListHeader\'><b> Social Responsibility:</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>\
                        <li> demonstrate awareness and interest in learning more about social issues? </li>\
                        <li> participate in P3 events and discussions? </li></ul>\

                      <div class = \'ideaListHeader\'><b> Participation</b> Does #{associate_consultant} </div>\
                      <ul class = \'ideaListElement\'>
                        <li> volunteer to organize or attend events? </li>\
                        <li> actively contribute to the betterment of TW (ex: recruiting, provide feedback for AC Learning Plan)? </li></ul>\
                    </p>")

    questions
  end
end
