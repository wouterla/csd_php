# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.define :build do |build_config|
    build_config.vm.host_name = "build"
    build_config.vm.box = "dev_box"
    build_config.vm.box_url = "http://files.vagrantup.com/precise32.box"
    build_config.vm.network "forwarded_port", guest: 8080, host: 8080 # jenkins port
    build_config.vm.network "forwarded_port", guest: 8081, host: 8081 # fitnesse port
	
	# share jenkins conf so it can be version controlled *and* configured through the UI
	build_config.vm.synced_folder "jenkins/", "/var/lib/jenkins/", :id => "jenkins-dir", :mount_options => ["uid=106", "gid=1004", "dmode=775", "fmode=775"]
	
	# share fitnesse root dir so it can be version controlled *and* configured through the UI
    build_config.vm.synced_folder "FitNesseRoot/", "/var/lib/fitnesse/FitNesseRoot/", :id => "fitnesse-dir", :mount_options => ["uid=1001", "gid=1003", "dmode=775", "fmode=775"]

	# Use pupped for further provisioning
    build_config.vm.provision "puppet" do |build_puppet|
      build_puppet.manifests_path = "manifests"
      build_puppet.manifest_file = "build.pp"
      build_puppet.module_path = "modules"
    end
  end
	
end
