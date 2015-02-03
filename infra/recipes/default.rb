USER = "vagrant"
WORKSPACE = "/home/vagrant/workspace"
PATH = "/opt/rbenv/shims:/opt/rbenv/bin:/opt/rbenv/plugins/ruby_build/bin:#{ENV['PATH']}";
BUNDLE_PATH = "~/bundle"
ENVIRONMENT = {
  "PATH" => "#{PATH}",
  "BUNDLE_PATH" => "#{BUNDLE_PATH}"
}

# Install rbenv
include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"

RUBY_VERSION = "1.9.3-p448"
# Install Ruby 1.9.3-p448
rbenv_ruby "#{RUBY_VERSION}" do
  ruby_version "#{RUBY_VERSION}"
  global true
end

# Install Bundler gem
rbenv_gem "bundler" do
  ruby_version "#{RUBY_VERSION}"
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

# Install Phantomjs for functional tests
package "phantomjs"

# Add the BUNDLE_PATH as an environment variable
bash "add_bundle_path" do
  user "root"
  cwd "/etc"
  code <<-EOT
    echo "export BUNDLE_PATH=#{BUNDLE_PATH}" >> /etc/profile.d/bundle.sh
  EOT
end
