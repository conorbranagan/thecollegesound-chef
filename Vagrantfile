# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu-12.04"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "192.168.33.10"

  config.omnibus.chef_version = "11.6.2"
  config.berkshelf.enabled = true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider :virtualbox do |vb|
  #   # Don't boot with headless mode
  #   vb.gui = true
  #
  #   # Use VBoxManage to customize the VM. For example to change memory:
  #   vb.customize ["modifyvm", :id, "--memory", "1024"]
  # end
  #
  # View the documentation for the provider you're using for more
  # information on available options.

  # Share the development
  config.vm.synced_folder "../thecollegesound", "/home/vagrant/workspace", :create => true, :nfs => true

  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      "apt",
      "workspace",
      "mysql::server",
      "nginx",
      "gunicorn",
      "thecollegesound",
    ]

    chef.json = {
      "workspace" => {
        "owner" => "vagrant"
      },
      "mysql" => {
        "server_root_password" => "thec0lleges0und",
        "server_debian_password" => "thec0lleges0und",
        "server_repl_password" => "thec0lleges0und"
      },
      "thecollegesound" => {
        "app_root" => "/home/vagrant/workspace",
        "ssh_key" => File.open("#{ENV['HOME']}/.ssh/tcs-chef") {|f| f.read},
        "debug" => true,
        "deploy_from_git" => false
      }
    }
  end
end
