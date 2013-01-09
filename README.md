ReviewSite
==========

How to contribute time/effort to the ReviewSite
-----------------------------------------------

* Check out this project, and use the provided vagrantbox to do development/testing
* For any changes, include updated/added unit tests, and ensure that the whole suite runs
* Push changes to github
* Push changes to the 'dev' site (ask Aleks/Casey/Robin for access to it)
* Manually test the changes there too, using the accounts that are provided by the above people
* Request that the changes be pushed to the 'prod' site by robin


Development Setup instructions:
-------------------------------
The ReviewSite codebase includes a vagrantbox for local development and testing.

To use this, you must checkout and build the vagrantbox.

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
* `rspec spec`

Start the local server
----------------------

Create a local .env file:
(inside the VM)

* `$ echo "PORT=9292" > .env`
* `$ echo "RACK_ENV=development" >> .env`

Start the server:

* `$ foreman start` (this will not return)
