# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/wily64"

  # Skip checking for box updates. Speed up vagrant up.
  config.vm.box_check_update = false

  # Set hostname.
  config.vm.hostname = "guest"

  # Port forwarding.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Only host should be able to access guest OS.
  config.vm.network "private_network", ip: "192.168.33.10"

  # Have VM show in the same network as guest OS.
  # config.vm.network "public_network"
  # Example how to make Vagrant not ask for bridged networking interface.
  # config.vm.network "public_network", bridge: 'en0: Wi-Fi (AirPort)'

  # Folder sharing.
  config.vm.synced_folder ".", "/vagrant", :owner => "vagrant"
  config.vm.synced_folder "project", "/usr/local/var/www/myproject", :owner => "vagrant"

  if Dir.exists?("vendor/rzajac/vagrant-prov")
    provision_dir = "vendor/rzajac/vagrant-prov/provision"
  else
    provision_dir = "provision"
  end

  config.vm.synced_folder provision_dir, "/provision", :owner => "vagrant"

  # VirtualBox configuration.
  config.vm.provider "virtualbox" do |vb|
      # Run without GIU
      vb.gui = false

      # Set the name for the VM
      vb.name = "MyProject"

      # Use VBoxManage to customize the VM. For example to change memory:
      vb.customize ["modifyvm", :id, "--memory", "2048"]
      #vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--cpuexecutioncap", "95"]
      
      vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
   end

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # Provision the VM.
  config.vm.provision :shell, :path => provision_dir + "/main-provision.sh", :keep_color => true

  # Copy files from the host machine.
  # config.vm.provision :file, source: "~/.gitconfig", destination: "/home/vagrant/.gitconfig"
end
