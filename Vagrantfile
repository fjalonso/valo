# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    
  # Load config JSON.
  config_json = JSON.parse(File.read("config.json"))

  # Prepare base box.
  config.vm.box = "ubuntu/trusty64"

  # Configure networking.
  config.vm.network :private_network, ip: config_json["vm"]["ip"]

  # Configure forwarded ports.
  config.vm.network "forwarded_port", guest: 35729, host: 35729, protocol: "tcp", auto_correct: true
  config.vm.network "forwarded_port", guest: 8983, host: 8983, protocol: "tcp", auto_correct: true
  # User defined forwarded ports.
  config_json["vm"]["forwarded_ports"].each do |port|
    config.vm.network "forwarded_port", guest: port["guest_port"],
      host: port["host_port"], protocol: port["protocol"], auto_correct: true
  end

  # Customize provider.
  config.vm.provider :virtualbox do |vb|
      
    # Uncomment if problems installing
    #vb.gui = true
      
    # RAM.
    vb.customize ["modifyvm", :id, "--memory", config_json["vm"]["memory"]]

    # Synced Folders.
    config_json["vm"]["synced_folders"].each do |folder|
      case folder["type"]
      when "nfs"
        config.vm.synced_folder folder["host_path"], folder["guest_path"], type: "nfs"
        # This uses uid and gid of the user that started vagrant.
        config.nfs.map_uid = Process.uid
        config.nfs.map_gid = Process.gid
      else
        config.vm.synced_folder folder["host_path"], folder["guest_path"]
      end
    end
  end

  # Run initial shell script.
  config.vm.provision :shell, :path => "bootstrap.sh"

end
