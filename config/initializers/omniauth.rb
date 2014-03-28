Rails.application.config.middleware.use OmniAuth::Builder do
  provider :saml,
           :assertion_consumer_service_url     => ENV['URL_CALLBACK'],
           :issuer                             => "TW Review Site",
           :idp_sso_target_url                 => "https://thoughtworks.oktapreview.com/app/template_saml_2_0/k208u3xtTCAPGDHDUFON/sso/saml",
           :idp_cert                           => ENV['CERTIFICATE'],
           :name_identifier_format             => "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
end