require 'serverspec'

# Required by serverspec
set :backend, :exec
set :path, '/opt/rbenv/bin:/opt/rbenv/shims:$PATH'

RSpec.configure do |c|
  user    = 'vagrant'
end

# Ruby 1.9.3-p448
describe command('rbenv global 1.9.3-p448 && rbenv version') do
  its(:stdout) { should match '1.9.3-p448' }
end

# Bundle
describe command('which bundle') do
  its(:stdout) { should match '/opt/rbenv/shims/bundle' }
end

# Postgresql
describe service('postgresql') do
  it { should be_running }
end

# Node.js (required by Rails 3 asset pipeline)
describe package('nodejs') do
  it { should be_installed }
end

# Packages for capybara-webkit
describe package('xvfb') do
  it { should be_installed }
end

describe package('qt4-dev-tools') do
  it { should be_installed }
end

# Phantomjs
describe package('phantomjs') do
  it { should be_installed }
end

# Fontconfig for phantomjs
describe package('fontconfig') do
  it { should be_installed }
end
