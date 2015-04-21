class InvitationMessageBuilder
	attr_reader :successes,
							:errors

	def initialize(no_email)
		@no_email = no_email
		@successes = []
		@errors = []
		@invitation
	end

	def build(message)
    if @invitation.save 
    	add_success(message)
    else
      add_errors
    end
	end

	def with(invitation)
		@invitation = invitation
		self
	end

	def error_message
  	errors.join('\n')
  end
	
	def success_message
    if successes? && no_email?
      'An invitation has been created for: ' + successes.join(', ')
    elsif successes?
      'An invitation has been sent to: ' + successes.join(', ')
    end
  end

  private 

  	attr_reader :invitation

		def add_error(message)
			errors << message
		end

		def add_errors
		  @invitation.errors.messages.values.flatten.map { |error| add_error(error) }
		end

		def add_success(message)
			successes << message
		end

		def no_email?
			@no_email
		end

		def successes?
			successes.any?
		end
end