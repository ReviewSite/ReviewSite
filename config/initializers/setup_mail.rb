ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "twreviewsite.herokuapp.com",
    :user_name            => "smtp@thoughtworks.org",
    :password             => "Th0ughtW0rks@2013",
    :authentication       => "plain",
    :enable_starttls_auto => true
}
