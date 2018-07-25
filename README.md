# ACES Deployment Tools


## Server Requirements

- Server OS: Ubuntu 16.04+ (requires systemd init system)
- Memory: 4GB+ (for a server running 2-4 ACES services, running more services may require more memory)
- Disk Space: 1GB minimum (running blockchain services such as bitcoind and geth require additional disk space).

## Install Ansible

Install Ansible on the control machine (the machine which you will be deploying from) 
by following the [Ansible Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).


## Install Ansible Packages

Once Ansible is installed, you will need to also install the Ansible Galaxy packages 
required by ACES deployments:

```bash
ansible-galaxy install -r requirements.yml
```


## Getting Started

This repository provides Ansible roles for deploying all the key components of an ACES node.
Ansible roles can be combined and configured to deploy ACES nodes with different compositions
of services depending on the needs of the service provider.

### Roles

## ACES Listener Roles

* [ACES Ark Listener](roles/aces-listener-ark)
* [ACES Bitcoin Listener](roles/aces-listener-bitcoin)
* [ACES Ethereum Listener](roles/aces-listener-ethereum)

## ACES Service Roles

* [ACES Ark-Bitcoin Channel Service](roles/aces-ark-bitcoin-channel-service)
* [ACES Ark-Ethereum Channel Service](roles/aces-ark-ethereum-channel-service)
* [ACES Ark-Ethereum Contract Service](roles/aces-ark-ethereum-contract-service)
* [ACES Arka-Arkb Channel Service](roles/aces-arka-arkb-channel-service)
* [ACES Bitcoin-Ark Channel Service](roles/aces-bitcoin-ark-channel-service)
* [ACES Ethereum-Ark Channel Service](roles/aces-ethereum-ark-channel-service)

## ACES Marketplace Role

* [ACES Marketplace](roles/aces-marketplace)

## Blockchain Provider Roles

* [Bitcoind](roles/bitcoind)
* [Ethereum](roles/ethereum)


### Common Patterns

#### Web Service Configurations

The Ansible roles that provide web services (i.e ACES Listener and Services) have support 
for exposing the web service in one of three different ways:

##### Locally exposed HTTP port

Using this option, the role provided web service is exposed locally on the application
port. This option is best used to when the service is used directly over the 
web app port on the same server. This method might be used for a listener service that
is consumed by a channel service both running on the same node where the listener service
is not exposed to the public, but the channel service is.

Use this method by setting the `install_nginx_proxy` parameter to `false` in the role arguments: 

```yaml
install_nginx_proxy: false
```

To expose the port to outside traffic (for example to expose publicly or to the host 
machine when running services in a VM), set the `expose_port` option to `true`:

```yaml
expose_port: true
```


##### Local domain with https using self-signed certs (default)

Using this option, services are given a domain name and the service is accessible
directly using the domain name over https using self-signed certs. 

Use this method by setting the following in the role arguments:

```yaml
install_nginx_proxy: false
use_letsencrypt: false
domain_name: my-aces-service.example.com
```

Add the following to your host machine's `/etc/hosts` file:

```bash
127.0.0.1 my-aces-service.example.com
```

You can then access the service on the host machine though a web browser by visiting:

```
https://my-aces-service.example.com
```


##### Public domain with https using LetsEncrypt

Using this option, services are given a publicly registered domain name and https encryption
is enabled using LetsEncrypt issues SSL certificates.

You must create a DNS A record pointing your registered domain name to your server IP before
running the Ansible deployment scripts since LetsEncrypt must ping the server externally
to verify ownership of the domain name.

Use this method by setting the following in the role arguments:

```yaml
install_nginx_proxy: true
use_letsencrypt: true
domain_name: my-aces-service.example.com
letsencrypt_email: change_me@example.com
```

You can then access the service using the following URL:

```
https://my-aces-service.example.com
```


### Application Port

Each web service deployed to an ACES node must have a unique `app_port`
defined in the playbook role parameters.

The `app_port` parameter defines what TCP port the web service is exposed on. Only one application
is allowed to listen on a given port, so every `app_port` defined in your playbook must be 
unique. It is recommended that `app_ports` be an integer above `1024` since port numbers under
`1024` are registered to common services that may already be running on a server (for example
port 22 is normally reserved for SSH access).

ACES Ansible roles use nginx web server reverse proxying to route port 80 (default http port) 
and port 443 (default https port) to the underlying `app_port` defined for your service.


### Application Service Name

Each web service deployed to an ACES node must have a unique `app_service_name`
defined in the playbook role parameters.

ACES nodes use `systemd` to supervise services running on the server. Using `systemd`, 
each service is identified uniquely using the role's `app_service_name` parameter.

Inside the server, the service logs can be obtained using the `app_service_name` (replace
`{{app_service_name}}` with your role configured `app_service_name`):

```bash
sudo journalctl -u {{app_service_name}} -f
```

Services can also be restarted, stopped, and started using `systemd`:

```bash
sudo service {{app_service_name}} restart
```

```bash
sudo service {{app_service_name}} stop
```

```bash
sudo service {{app_service_name}} start
```

### Creating A Playbook

Create an Ansible playbook for your ACES node deployment by copying the following template
into a file `my-aces-node-playbook.yml`:

```yaml
---
- import_playbook: setup-playbook.yml
- hosts: aces-node-1
  become: true
  roles:
    - role: aces-common
```

Roles availble can be found in the `roles` directory. Each role has a number of configurable
parameters under the role directory's `defaults/main.yml` configuration file. When adding a 
new role to your playbook, just copy all the paramters under `defaults/main.yml` under your
playbooks role and change the values as desired.

```yaml
---
- import_playbook: setup-playbook.yml
- hosts: aces-node-1
  become: true
  roles:
    - role: aces-common
    - role: bitcoind
      bitcoind_data_directory: /var/bitcoin
      bitcoind_rpc_user: my-bitcoin-rcp-user
      bitcoind_rpc_password: my-super-secure-bitcoind-rpc-password
      is_testnet: true
```

See example playbooks in the next section for more examples.


## Example Playbooks

Each ACES node can be configured to run different services depending on the needs of 
the service provider. Each node configuration is defined by an Ansible playbook that
defines a composition of the roles to be installed on the target server.

We have provided several example configurations for some common setups, such as
running a node for ACES Listeners and Channel Services.

* [ACES Ark Listener Playbook](aces-ark-listener-playbook.yml)
* [ACES Bitcoin Listener Playbook](aces-bitcoin-listener-playbook.yml)
* [ACES Ethereum Listener Playbook](aces-ethereum-listener-playbook.yml)
* [ACES ARKa-ARKb Unidirectional Channel Playbook](aces-arka-arkb-unidirectional-channel-service-playbook.yml)
* [ACES ARKa-ARKb Bidirectional Channel Playbook](aces-arka-arkb-bidirectional-channel-service-playbook.yml)
* [ACES Ark-Bitcoin Channel Playbook](aces-ark-bitcoin-channel-service-playbook.yml)
* [ACES Bitcoin-Ark Channel Playbook](aces-bitcoin-ark-channel-service-playbook.yml)
* [ACES Ark-Ethereum Channel Playbook](aces-ark-ethereum-channel-service-playbook.yml)
* [ACES Ethereum-Ark Channel Playbook](aces-ethereum-ark-channel-service-playbook.yml)
* [ACES Marketplace Playbook](aces-marketplace-playbook.yml)


## Local VM Server Deployments

This section describes how to to deploy an ACES node Ansible playbook to a local
VM for development and testing.

Following the [Vagrant Installation Guide](https://www.vagrantup.com/docs/installation/) and
use the `Vagrantfile` in this repository to start a local Ubuntu 16.04 server to deploy
your Ansible playbook to:

```bash
vagrant up
```

Get ssh port and key path from vagrant ssh-config using `vagrant ssh-config` 
and update the Ansible `inventory` file to match your VM's ssh host and port.

Deploy your ACES node playbook to the Vagrant VM, by running the example `ansible-playbook`
command below, replacing `{{playbook}}` with your playbook file:

```bash
ansible-playbook -u ubuntu --private-key=.vagrant/machines/aces-node-1/virtualbox/private_key \
-i inventory {{playbook}}.yml
```

Example:

```bash
ansible-playbook -u ubuntu --private-key=.vagrant/machines/aces-node-1/virtualbox/private_key \
-i inventory aces-ark-listener-playbook.yml
```


## Remote Server Deployments

This section describes how to deploy an ACES node Ansible playbook to a remote server.

1. Create your server instance on any cloud infrastructure provider and download the 
ssh keys for your user:
   
    * [AWS Tutorial](https://aws.amazon.com/blogs/apn/getting-started-with-ansible-and-dynamic-amazon-ec2-inventory-management/)
    * [Linode Tutorial](https://www.linode.com/docs/applications/configuration-management/automatically-configure-servers-with-ansible-and-playbooks/)
     
2. Create an Ansible inventory file and configure it to point to your remote server by
following the [Ansible Working with Inventory Guide](https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)

3. Create an Ansible playbook for your desired configuration by composing the provided roles with your 
   custom parameters
   
4. Run your playbook with `ansbile-playbook`, providing your Ansible inventory and ssh key:

    ```bash
    ansible-playbook -u ubuntu --private-key=.vagrant/machines/aces-node-1/virtualbox/private_key \
    -i inventory {{playbook}}.yml
    ```


## Maintaining Nodes

Updating your service apps is as easy as re-deploying your Ansible playbook. The playbooks are
designed to be idempotent, which means they can be run any number of times and the resulting
state of the server should be the same. The ACES Ansible roles for installing ACES applications
such as ACES Services and Listeners always pull the latest code (develop branch) from the 
corresponding github repositories. 


### Backups

Backups should be made for configuration data for the installed apps under `/etc/opt/` and `/opt/`,
as well as any installed by Ansible roles:
 
* [Backup PostgreSQL databases](https://www.postgresql.org/docs/9.1/static/backup.html)


If any blockchains are running on the node such as bitcoin or ethereum, the corresponding
wallet data directories that may store private keys should be backed up as well according to the
instructions provided in the blockchain documentation:

* [Backing up Bitcoin Wallets](https://en.bitcoin.it/wiki/Backingup_your_wallet)
* [Backing up Ethereum Wallets](https://kb.myetherwallet.com/getting-started/backing-up-your-new-wallet.html) 
