# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu-14.04"
  config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network :private_network, ip: "192.168.33.10"

  config.omnibus.chef_version = :latest
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
    chef.log_level = "debug"

    chef.run_list = [
      "apt",
      "workspace",
      "mysql::server",
      "mysql::client",
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
        "app_root" => "/srv/thecollegesound",
        "debug" => true,
        "deploy_from_git" => true,
        "ssh_key" => File.open("#{ENV['HOME']}/.ssh/id_rsa") {|f| f.read},
      }
    }
  end
end
