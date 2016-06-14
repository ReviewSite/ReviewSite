#!/usr/bin/env bash

bundle install
bundle exec rake db:drop db:create db:migrate db:seed
RAILS_ENV=test bundle exec rake db:drop db:create db:migrate
