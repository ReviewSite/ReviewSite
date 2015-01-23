# Install rbenv
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

# Install Ruby 1.9.3-p448
rbenv_ruby "1.9.3-p448" do
  ruby_version "1.9.3-p448"
  global true
end

# Install Bundler gem
rbenv_gem "bundler" do
  ruby_version "1.9.3-p448"
end

# Install postgresql database
include_recipe "postgresql::server_debian"

# Change postgres password (untested)
execute "change_postgres_password" do
  command "echo \"ALTER USER Postgres WITH PASSWORD 'password'\" | sudo -u postgres psql"
end

# Install Node.js (required by Rails 3 asset pipeline)
include_recipe "nodejs"

# Install xvfb and qt4-dev-tools
package "xvfb"
package "qt4-dev-tools"
