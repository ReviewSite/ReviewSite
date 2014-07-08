TravisCI: 
[![Build Status](https://travis-ci.org/ReviewSite/ReviewSite.png?branch=master)](https://travis-ci.org/ReviewSite/ReviewSite)

SnapCI:
[![Build Status](https://snap-ci.com/ReviewSite/ReviewSite/branch/master/build_image)](https://snap-ci.com/ReviewSite/ReviewSite/branch/master)


Project Setup
=============

* Fork the repo
* Install VirtualBox
* Install Vagrant
* Request access to Okta Preview from TechOps


Spin up the Vagrant box
-----------------------

* `cd vagrant_postgres91_utf8_rails`
* `vagrant up`  
  * vagrant up will provision the Vagrant box, create the databases, and run the bundler
* `vagrant ssh`
* `cd workspace`


Set up the local environment
----------------------------

* `$ echo "PORT=9292" > .env`
* `$ echo "RACK_ENV=development" >> .env`
* `rake db:schema:load`
  * loads the latest schema without going through each migration individually (faster than rake db:migrate)
* `rake db:seed`
  * add dummy data to local environment
* `RAILS_ENV=test rake db:schema:load`
  * set up test environment
 

Run the test suite
------------------

* Using capybara-webkit
  * `xvfb-run rspec`
  * If you repeatedly receive the error "Xvfb failed to start," try `xvfb-run --server-num=1 rspec spec`.
* Using poltergeist
  * `rspec`


Start the local server
----------------------

* `$ foreman start` (this will not return)

If your foreman is very slow, try getting a new network setup:

* `$ sudo dhclient` (this will give a File Exists, that's ok)
* `$ foreman start `

View the dev site locally:

* http://localhost:9292/


Deploying the ReviewSite to heroku
==================================

When deploying heroku to a new heroku instance (developers will NOT need to do
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


Questions?
==========

Email Valerie (varoske@thoughtworks)
