class Comments < SitePrism::Section

	element :comments_box, '#feedback_comments'
	element :save_button, '#review_general_comments + div > input.btn'

end