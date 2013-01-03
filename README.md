ReviewSite
==========

Development Setup instructions:

Create a local .env file:
$ echo "PORT=9292" > .env
$ echo "RACK_ENV=development" >> .env

Set your local git credentials
------------------------------

$ git config --local user.name "Robin Dunlop" (Enter YOUR name instead)
$ git config --local user.email rdunlop@thoughtworks.com (Enter YOUR email instead)

Start the Development Environment
=================================
cd vagrant_postgres91_utf8_rails
vagrant up (this will also create the databases, and run the bundler)
vagrant ssh

Migrate the database (necessary if you make changes to the db schema in development)
------------------------------------------------------------------------------------
(inside the VM)
cd workspace
rake db:migrate

Create/Migrate the TEST db environment
--------------------------------------
(inside the VM)
cd workspace
RAILS_ENV=test rake db:migrate


Run the test suite
------------------
(inside the VM)
cd workspace
rspec spec
