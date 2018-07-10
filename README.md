# ACES Deployment Tools


## Requirements

- Server OS: Ubuntu 16.04+ (requires systemd init system)
- Server Mem: 4GB+


## Installation

Install Ansible on the control machine (the machine which you will be deploying from) 
using the following instructions:
https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

Install required Ansible packages:

```
ansible-galaxy install -r requirements.yml
```


## Local ACES Node deployment

Create VM server with ip `172.17.177.21` from the given `Vagrantfile`:

```
vagrant up
```

Get ssh key path from vagrant ssh-config:

```
vagrant ssh-config
```

Deploy ACES node to vagrant instance, replacing `{{playbook}}` with the desired playbook file:

```
ansible-playbook --verbose \
-u ubuntu \
--private-key=./.vagrant/machines/aces-service-node-1/virtualbox/private_key \
-i ./inventory \
./{{playbook}}.yml
```

Example:

```
ansible-playbook --verbose \
-u ubuntu \
--private-key=./.vagrant/machines/aces-service-node-1/virtualbox/private_key \
-i ./inventory \
./aces-ark-listener-playbook.yml
```
