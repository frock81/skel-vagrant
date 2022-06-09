# Skel Vagrant

A **simple** [Ansible](https://www.ansible.com/) based project skeleton using [Vagrant](https://www.vagrantup.com/), [Virtualbox](https://www.virtualbox.org/) and [Cookiecutter](https://github.com/cookiecutter/cookiecutter) as tooling.


Vagrant provides the virtual machines (*vms*, in this article) configuration that will be used in the local development environment (that shall move to a dev, staging or production environment afterwards).

Virtualbox is used as the Vagrant provider because the portability between Linux, Windows and Mac and the ease of use also.

Cookiecutter moves the project template to the real one.

## Requirements

Working Vagrant, Virtualbox and Cookiecutter (and so a Python interpreter) installation. See each tool site for details. Ansible is not required to create the new project boilerplate.

## Running

> **TO BE REVIEWED**: review these steps

 1. **"Cookiecutter" the project**: `cookiecutter https://github.com/frock81/skel-vagrant`

## More

The core of the project is the cookiecutter.json file, that holds the main project config, and the Vagrantfile inside the template directory (`{{ cookiecutter.project_slug }}`), that holds the virtual machines config.

## File cookiecutter.json

The file holds the following keys:

##### project_name

The name of the project. Can include spaces that will be removed to form the `project_slug` in a default config (that can be overriden too).

Defaults to `My New Project`.

##### project_slug

> **TO BE UPDATED**: the directory name and possibly other places, I believe.

The project slug. That will be used to ...

Defaults to a lower version with spaces replaced by dashes of the project name, `my-new-project` in the default config.

##### vagrant_box

The Vagrant box that will be used. See the [Vagrant Cloud site](https://app.vagrantup.com/boxes/search) to discover Vagrant boxes.

Defaults to `ubuntu/focal64` (20.04 LTS)

##### vm_cpus

The number of cpus allocated to each machine. To keep the project simple, all the vms get the same number.

Defaults to `1`.

##### vm_memory

The amount of memory allocated to each machine. To keep the project simple, all the vms get the same amount.

Defaults to `512`.

##### vm_name

The prefix used in the vm name creation process.

Defaults to `vm`.

##### instance_index_start

The vm suffix index for the first vm that will be created (for example vm-**1**).

Defaults to `1`. One may prefer to start from 0, for example (that would result vm-0 name for the first created vm).

##### instance_index_end

The vm suffix index for the lasa vm that wil be created (for example vm-**3**). Together with the `instance_start` parameter, it will determine the amount of vms. For example, with an `instance_index_start` of 0 and an `instance_index_end` of 2, three vms will be created.

Defaults to `2` (so two virtual machines will be created in the default config).

##### ip_prefix

The prefix for the IP address. The IP address for the machines will be generated using the instance start|end index and the prefix. So in the default confing it will be 192.168.4.11 for vm-1, 192.168.4.12 for vm-2 and so on.

Pay attention to possible IP adressess conflicts in the Vagrant private network.

Defaults to `192.168.128.1`.

##### domain_name

The local DNS suffix.

Defaults to `localdomain`.

##### apt_cacher_url

If you usually downloads packages, using a cache is a good idea. Since I'm using mostly Debian/Ubuntu derivatives, there is an apt-cacher URL option in the Cookiecutter JSON config.

> TO BE UPDATED: don't remember, for now, why this is an array and what sane default to use.

Defaults to `["", "http://10.0.2.2:3142"]`.

##### vm_ansible_group

The group to assign the new created vms. The default config adds the suffix `_servers` to the vm name, so, for example, vms _db-1_ and _db-2_ would be assigned to the group _db_servers_.

Defaults to `vm_servers`.

##### _copy_without_render

Don't mess with it. Theses are files that Cookiecutter will not process.
