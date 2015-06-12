require "serverspec"

USER = "vagrant"
WORKSPACE = "/home/#{USER}/workspace"
PATH = "/opt/rbenv/shims:/opt/rbenv/bin:/opt/rbenv/plugins/ruby_build/bin:$PATH";
BUNDLE_PATH = "~/bundle"

# Required by serverspec
set :backend, :exec
set :path, PATH

RSpec.configure do |c|
  user    = USER
end

# Ruby 2.1.6
describe command("rbenv global 2.1.6 && rbenv version") do
  its(:stdout) { should match "2.1.6" }
end

# Bundle
describe command("which bundle") do
  its(:stdout) { should match "/opt/rbenv/shims/bundle" }
end

describe command("cd #{WORKSPACE} && bundle install") do
  its(:exit_status) { should eq 0 }
end

# Postgresql
describe service("postgresql") do
  it { should be_running }
end

describe command("cd #{WORKSPACE} && bundle exec rake db:drop db:create db:migrate db:seed") do
  its(:exit_status) { should eq 0 }
end

describe command("cd #{WORKSPACE} && bundle exec RAILS_ENV=test rake db:drop db:create db:migrate") do
  its(:exit_status) { should eq 0 }
end

# Node.js (required by Rails 3 asset pipeline)
describe package("nodejs") do
  it { should be_installed }
end

# Packages for capybara-webkit
describe package("xvfb") do
  it { should be_installed }
end

describe package("qt4-dev-tools") do
  it { should be_installed }
end

# Phantomjs
describe package("phantomjs") do
  it { should be_installed }
end

# Fontconfig for phantomjs
describe package("fontconfig") do
  it { should be_installed }
end

# Bundle Path
describe command("sudo cat /etc/profile.d/bundle.sh") do
  its(:stdout) { should match "export BUNDLE_PATH=#{BUNDLE_PATH}" }
end
