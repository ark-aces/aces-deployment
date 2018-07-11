Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu/xenial64"
    
    config.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
    end
    
    config.vm.define "aces-node-1" do | node |
        node.vm.hostname = "aces-node-1"
        node.vm.network :forwarded_port, guest: 80, host: 8080
        node.vm.network :forwarded_port, guest: 443, host: 8443
    end
    
    config.vm.provision "shell" do |script|
        script.inline = "apt-get install -y python"
    end
end
