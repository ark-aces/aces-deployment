Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu/xenial64"
    
    config.vm.provider "virtualbox" do |vb|
        vb.memory = "1524"
    end
    
    config.vm.define "aces-service-node-1" do | node |
        node.vm.network "private_network", ip: "172.17.177.21"
        node.vm.hostname = "aces-service-node-1"
    end
    
    config.vm.define "aces-marketplace-node-1" do | node |
        node.vm.network "private_network", ip: "172.17.177.22"
        node.vm.hostname = "aces-marketplace-node-1"
    end

    config.vm.provision "shell" do |script|
        script.inline = "apt-get install -y python"
    end
end
