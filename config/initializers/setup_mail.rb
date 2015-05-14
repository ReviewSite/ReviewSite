ActionMailer::Base.smtp_settings = {
  :address              => ENV['MAIL_SERVER'],
  :port                 => ENV['MAIL_PORT'],
  :domain               => ENV['MAIL_DOMAIN'],
  :user_name            => ENV['MAIL_USERNAME'],
  :password             => ENV['MAIL_PASSWORD'],
  :authentication       => "plain",
  :enable_starttls_auto => (ENV['MAIL_TLS'].nil? ? true : ENV['MAIL_TLS'] == 'true')
}
ActionMailer::Base.default :from => ENV['MAIL_FULL_EMAIL']

unless ENV['DOMAIN'].nil?
  ActionMailer::Base.default_url_options[:host] = ENV['DOMAIN']
end

unless ENV['EMAIL_OVERRIDE'].nil?
    class OverrideMailRecipient
        def self.delivering_email(mail)
            mail.body = "DEVELOPMENT-OVERRIDE. Was being sent to " + mail.to.first + "\n" + mail.body.to_s
            mail.to = ENV['EMAIL_OVERRIDE']
            mail.bcc = ENV['EMAIL_BCC_OVERRIDE']
        end
    end
    ActionMailer::Base.register_interceptor(OverrideMailRecipient)
end