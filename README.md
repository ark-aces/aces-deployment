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

Create VM with the given `Vagrantfile`:

```
vagrant up
```

Get ssh port and key path from vagrant ssh-config using `vagrant ssh-config` 
and update the ansible `inventory` file to match your VM's ssh host and port.

Deploy ACES node to vagrant instance, replacing `{{playbook}}` with your playbook file:

```
ansible-playbook --verbose \
-u ubuntu \
--private-key=./.vagrant/machines/aces-node-1/virtualbox/private_key \
-i ./inventory \
./{{playbook}}.yml
```

Example:

```
ansible-playbook --verbose \
-u ubuntu \
--private-key=./.vagrant/machines/aces-node-1/virtualbox/private_key \
-i ./inventory \
./aces-ark-listener-playbook.yml
```


## Server Deployments

1. Create your server instance on any cloud infrastructure provider and download the 
   ssh keys for your user
   
2. Add your server info to an ansbile `inventory` file

3. Set up a playbook for your desired configuration by composing the provided roles with your 
   custom parameters
   
4. Install python on the target server using the `setup-playbook.yml` 
   (needed to run some ansible server side code for collecting info)
   
4. Run your playbook with `ansbile-playbook`, providing your ansible inventory and ssh key
