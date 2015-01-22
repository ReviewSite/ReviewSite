# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 80, host: 9696
  config.vm.network "forwarded_port", guest: 80, host: 3000

  config.vm.synced_folder "../", "/home/vagrant/workspace"

  config.berkshelf.berksfile_path = "./infra/Berksfile"

  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = "./infra"
    chef.run_list = ['reviewsite']
  end

end
