# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.hostname = 'powerdns'

  config.vm.network 'private_network', ip: '172.28.128.40'

  config.vm.provider 'virtualbox' do |vb|
    vb.memory = 2*1024
    vb.cpus = 2
  end
  config.vm.provision 'shell', privileged: false, path: 'provision.sh'
end
