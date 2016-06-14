WORKSPACE = "/home/vagrant/workspace"

bash "create_virtual_framebuffer_for_functional_tests" do
  user "root"
  code <<-EOT
    Xvfb :1 -screen 0 1280x960x24 &
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
