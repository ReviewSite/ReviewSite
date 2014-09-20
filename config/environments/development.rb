ReviewSite::Application.configure do
  config.middleware.use ExceptionNotification::Rack,
    :email => {
      :email_prefix => "[ReviewSite Error] ",
      :sender_address => %{<do-not-reply@thoughtworks.org>},
      :exception_recipients => %w{error_recipient@example.com}
    }

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.alert = true
  end

  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  config.action_mailer.raise_delivery_errors = true

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Allow mailers to use named routes in emails
  config.action_mailer.default_url_options = { :host => "localhost:3000" }

  ENV['OKTA-TEST-MODE'] = "true"
  ENV['URL_CALLBACK'] = "http://localhost:9292/auth/saml/callback"
  ENV['TARGET_URL'] = "https://thoughtworks.oktapreview.com/app/template_saml_2_0/k2eulbsbVVITQLIFHADM/sso/saml"
  ENV['FINGERPRINT'] = "B8:53:D4:A7:E6:1B:86:FF:4E:91:F6:2D:34:EB:A6:A2:8F:89:9E:6F"
  ENV['URL'] = "https://localhost:9292"
end
