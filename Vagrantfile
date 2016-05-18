VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  # Configure cached packages to be shared between instances of the same base box.
  # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  unless Vagrant.has_plugin?("vagrant-omnibus")
    raise 'Missing vagrant plugin "vagrant-omnibus". Install with "vagrant plugin install vagrant-omnibus".'
  end

  config.vm.network "forwarded_port", guest: 9292, host: 3000
  config.vm.network "forwarded_port", guest: 3000, host: 3000

  config.vm.synced_folder "./", "/home/vagrant/workspace"
  config.omnibus.chef_version = '12.9.41'

  config.vm.provider "virtualbox" do |v|
    v.name = "review-site-box"
    v.memory = 1024
    v.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 10000]
  end

  config.berkshelf.berksfile_path = "./infra/Berksfile"
  config.berkshelf.enabled = true

  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = "./infra"
    chef.run_list = ['reviewsite']
  end
end
