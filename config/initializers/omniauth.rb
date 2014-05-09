Rails.application.config.middleware.use OmniAuth::Builder do
    provider :saml,
             :assertion_consumer_service_url     => "https://localhost:9292/auth/saml/callback",
             :issuer                             => "TW Review Site",
             :idp_sso_target_url                 => "https://thoughtworks.oktapreview.com/app/template_saml_2_0/k208u3xtTCAPGDHDUFON/sso/saml",
             :idp_cert                           => "-----BEGIN CERTIFICATE-----
                                                  MIICozCCAgygAwIBAgIGAT+fauIOMA0GCSqGSIb3DQEBBQUAMIGUMQswCQYDVQQGEwJVUzETMBEG
                                                  A1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsGA1UECgwET2t0YTEU
                                                  MBIGA1UECwwLU1NPUHJvdmlkZXIxFTATBgNVBAMMDHRob3VnaHR3b3JrczEcMBoGCSqGSIb3DQEJ
                                                  ARYNaW5mb0Bva3RhLmNvbTAeFw0xMzA3MDIxMjQ0NDlaFw00MzA3MDIxMjQ1NDlaMIGUMQswCQYD
                                                  VQQGEwJVUzETMBEGA1UECAwKQ2FsaWZvcm5pYTEWMBQGA1UEBwwNU2FuIEZyYW5jaXNjbzENMAsG
                                                  A1UECgwET2t0YTEUMBIGA1UECwwLU1NPUHJvdmlkZXIxFTATBgNVBAMMDHRob3VnaHR3b3JrczEc
                                                  MBoGCSqGSIb3DQEJARYNaW5mb0Bva3RhLmNvbTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEA
                                                  kAYqmCS63DBsav/zhCMNW38JQxW4hNgO15DCo2RvnkEN1jDK+pnAlRu6pGKJmpvVVx3K0zgSxNBM
                                                  XFvWCPfWdk1RaRoo+P/4pcMBAry/ysbVAJ3r1tpUuP9nMt4zuGkwL+TpnFUKVsS690fwID+mRydx
                                                  Ab1hTa3EcG5gXdu7pD0CAwEAATANBgkqhkiG9w0BAQUFAAOBgQAXWO+wxM6WSZ6MTZvdh2g1wF0d
                                                  GvZhS5LO3q2PUvq4qHx1SchiKbxje+CUHCqOOODOjQeD+SVcUBUPJ8I9OWi9aDiQjKnmpr87h8PH
                                                  +Ni1yB2C2KRHdxxSR6SfRjkyNeVEwzTyh2Y2zu+hghddKvllWQoSfwXhIcSrLKtsL71NrQ==
                                                  -----END CERTIFICATE-----",
             :name_identifier_format             => "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
end
