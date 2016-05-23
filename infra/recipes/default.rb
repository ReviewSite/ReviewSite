USER = "vagrant"
WORKSPACE = "/home/vagrant/workspace"
PATH = "/opt/rbenv/shims:/opt/rbenv/bin:/opt/rbenv/plugins/ruby_build/bin:#{ENV['PATH']}";
BUNDLE_PATH = "~/bundle"
ENVIRONMENT = {
    "PATH" => "#{PATH}",
    "BUNDLE_PATH" => "#{BUNDLE_PATH}"
}

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
include_recipe "postgresql::server"
include_recipe "nodejs"
package "xvfb"
package "firefox"
package "qt4-dev-tools"
package "phantomjs"

RUBY_VERSION = "2.1.6"
rbenv_ruby "#{RUBY_VERSION}" do
  ruby_version "#{RUBY_VERSION}"
  global true
end

rbenv_gem "bundler" do
  ruby_version "#{RUBY_VERSION}"
end

# Add the BUNDLE_PATH as an environment variable
bash "add_bundle_path" do
  user "root"
  cwd "/etc"
  code <<-EOT
    echo "export BUNDLE_PATH=#{BUNDLE_PATH}" >> /etc/profile.d/bundle.sh
  EOT
end

bash "create_virtual_framebuffer_for_functional_tests" do
  user "root"
  code <<-EOT
    sudo Xvfb :1 -screen 0 1024x768x24 &
    echo "export DISPLAY=:1" >> /etc/profile.d/bundle.sh
  EOT
end

# execute "bundle_install" do
#   command "cd #{WORKSPACE} && bundle install"
# end
#
# execute "create_and_prepare_development_database" do
#   command "cd #{WORKSPACE} && bundle exec rake db:drop db:create db:migrate db:seed"
# end
#
# execute "create_and_prepare_test_database" do
#   command "cd #{WORKSPACE} && RAILS_ENV=test bundle exec rake db:drop db:create db:migrate"
# end