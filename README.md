### [![Build Status](https://snap-ci.com/ReviewSite/ReviewSite/branch/master/build_image)](https://snap-ci.com/ReviewSite/ReviewSite/branch/master)


## Project Setup
* [Set up Git locally](https://github.com/ReviewSite/ReviewSite/wiki/1.-Setting-Up-Git-Locally)
* Fork the repo
* Install VirtualBox >= 4.3.26
* Install Vagrant >= 1.7.2
* Request access to the 1Password team -- email tw-review-site@thoughtworks.com for questions
    * Add application.yml file to config/
* Request access to Okta Preview from TechOps

#### Spin up the Vagrant box
    vagrant up
    vagrant ssh
    cd workspace

#### Start the local server
    $ bundle exec puma
View the dev site locally at `http://localhost:3000/`

#### Run the test suite
* All the tests (javascript + rspec)
  * `$ bundle exec rake spec:ci`
* All the rspec tests
  * `$ bundle exec rspec`
* One rspec test file
  * `$ bundle exec rspec spec/.../..._spec.rb`
* One rspec test block
  * `$ bundle exec rspec spec/.../..._spec.rb:40`
* Run the Jasmine tests
  * `$ RAILS_ENV=test bundle exec rake spec:javascript`
  * To run a single test: `$ RAILS_ENV=test bundle exec rake spec:javascript SPEC=my_test`
* See the wiki for a [guide on Manual Testing](https://github.com/ReviewSite/ReviewSite/wiki/3.-Manual-Testing-Guide)

## Deploying the ReviewSite to Heroku
When deploying to a new Heroku instance, please specify e-mail account settings in the following configuration
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
Any dev questions can be sent to tw-review-site@thoughtworks.com and it will be seen by all members of the Review Site team.
