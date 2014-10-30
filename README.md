### [![Build Status](https://snap-ci.com/ReviewSite/ReviewSite/branch/master/build_image)](https://snap-ci.com/ReviewSite/ReviewSite/branch/master)


## Project Setup
* Fork the repo
* Install VirtualBox
* Install Vagrant
* Request access to Okta Preview from TechOps

#### Spin up the Vagrant box
* `$ cd vagrant_postgres91_utf8_rails`
* `$ vagrant up`  
  * vagrant up will provision the Vagrant box, create the databases, and run the bundler
* `$ vagrant ssh`
* `$ cd workspace`

#### Set up the local environment
* `$ echo "PORT=9292" > .env`
* `$ echo "RACK_ENV=development" >> .env`
* `$ rake db:migrate`
* `$ rake db:seed`
* `$ RAILS_ENV=test rake db:migrate`

#### Run the test suite
* Using capybara-webkit
  * `$ xvfb-run rspec`
  * If you repeatedly receive the error "Xvfb failed to start," try `$ xvfb-run --server-num=1 rspec`.
* Using poltergeist
  * `$ rspec`
* For manual testing, see the wiki

#### Start the local server
* `$ foreman start` (this will not return)

If your foreman is very slow, try getting a new network setup:
* `$ sudo dhclient` (this will give a File Exists, that's ok)
* `$ foreman start `

View the dev site locally:
* http://localhost:9292/

## Deploying the ReviewSite to Heroku
When deploying to a new Heroku instance (developers will NOT need to do
this), please specify e-mail account settings in the following configuration
variables.

Account details for sending emails from:
* `MAIL_SERVER=smtp.gmail.com`
* `MAIL_PORT=587`
* `MAIL_DOMAIN=thoughtworks.org`
* `MAIL_USERNAME=do-not-reply@thoughtworks.org`
* `MAIL_PASSWORD=<password>`
* `MAIL_TLS=true`

The Address that should appear in the "from" line of the sent e-mails:
* `MAIL_FULL_EMAIL="TW ReviewSite <do-not-reply@thoughtworks.org>"`

The base domain that should be used for the links that appear in the emails.
* `DOMAIN=twreviewsite.herokuapp.com`

In order to prevent the mailer from sending e-mail on non-production heroku instance, 
it is possible to redirect all e-mail to an address that you control.
* `EMAIL_OVERRIDE=someone@somewhere.com`

## Questions?
* Valerie Roske, Tech Lead (varoske@thoughtworks)
* Alex Jablonski, Developer (ajablons@thoughtworks)
* Brandon Smith, Developer (ajablons@thoughtworks)
* Whitney Behr, QA (wlbehr@thoughtworks)
