ReviewSite

Build Status on TravisCI: [![Build
Status](https://travis-ci.org/ReviewSite/ReviewSite.png?branch=master)](https://travis-ci.org/ReviewSite/ReviewSite)

How to contribute time/effort to the ReviewSite
-----------------------------------------------

* Check out this project, and use the provided vagrantbox to do development/testing
* For any changes, include updated/added unit tests, and ensure that the whole suite runs
* Push changes to github
* [optional] Push changes to the 'dev' site (ask Aleks/Casey/Robin for access to it)
* Every week or so, change will be pushed to the 'dev' site for testing, and
  then, if no problems occur, promoted to "production" soon-thereafter
 * Ask Alex/Robin if you would like code promoted earlier.


Development Setup instructions:
-------------------------------
The ReviewSite codebase includes a vagrantbox for local development and testing.

To use this, you must checkout and build the vagrantbox.

* If Vagrant doesn't install properly, install Vagrant directly from the website at http://downloads.vagrantup.com/tags/v1.0.6, or install the vagrant gem

Set your local git credentials
------------------------------

* `$ git config --local user.name "Robin Dunlop" (Enter YOUR name instead)`
* `$ git config --local user.email rdunlop@thoughtworks.com (Enter YOUR email instead)`

Start the Development Environment
=================================

* `cd vagrant_postgres91_utf8_rails`
* `vagrant up (this will also create the databases, and run the bundler)`
* `vagrant ssh`

Migrate the database
--------------------
This step is necessary if you make changes to the db schema in development, or if you plan on running the server locally

(inside the VM)

* `cd workspace`
* `rake db:migrate`

Create/Migrate the TEST db environment
--------------------------------------

(inside the VM)

* `cd workspace`
* `RAILS_ENV=test rake db:migrate`


Run the test suite
------------------

(inside the VM)
* `cd workspace`
* `xvfb-run rspec spec`

Start the local server
----------------------

Create a local .env file:
(inside the VM)

* `$ echo "PORT=9292" > .env`
* `$ echo "RACK_ENV=development" >> .env`

Start the server:

* `$ foreman start` (this will not return)

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

* `MAIL_FULL_EMAIL=do-not-reply@thoughtworks.org`

The base domain that should be used for the links that appear in the emails.

* `DOMAIN=twreviewsite.herokuapp.com`

In order to prevent the mailer from sending e-mail on non-production heroku instance, 
it is possible to redirect all e-mail to an address that you control.

* `EMAIL_OVERRIDE=someone@somewhere.com`

