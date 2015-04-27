# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.network "forwarded_port", guest: 9292, host: 9292
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  config.vm.synced_folder "./", "/home/vagrant/workspace"

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end

  config.berkshelf.berksfile_path = "./infra/Berksfile"

  config.berkshelf.enabled = true

  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = "./infra"
    chef.run_list = ['reviewsite']
  end

end
