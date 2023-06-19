# Skel Vagrant

A **simple** skeleton for  [Ansible](https://www.ansible.com/) based IT infrastructure projects that use [Vagrant](https://www.vagrantup.com/) and [Virtualbox](https://www.virtualbox.org/) (as default Vagrant provider) as tooling for local development. This way one can create, develop and test IT infrastructure scenarios in an local computer.

## Requirements

Tools:

- A Python interpreter
- [Cookiecutter](https://github.com/cookiecutter/cookiecutter)
- Virtualbox
- Vagrant

The only tool needed to create the boilerplate project is Cookiecutter, but, for the project to be useful, one needs a Vagrant and Virtualbox working installation. See each tool site for details about installing and configuring. Since it aims Ansible projects, it is assumed that there will be a working Ansible installation too.

Cookiecutter creates the real project boilerplate from the project template.

Vagrant provides the virtual machines (*vms*, in this article) configuration that will be used in the local development environment (that shall move to a dev, staging or production env afterwards).

Virtualbox was chosen as the Vagrant provider because the portability between Linux, Windows and Mac and the ease of use also.

## Running

> **TO BE REVIEWED**: review these steps

 1. **"Cookiecutter" the project**: `cookiecutter https://github.com/frock81/skel-vagrant.git` or, if it is not the first time, `cookiecutter skel-vagrant` (you will be prompted for input)
 2. create a `~/.ansible_secret` folder with vault files inside it -- vault_pass_insecure (at least, with a [team shared] insecure password in it for development only), vault_pass_sudo (private to each developer), etc.
 3. Cd to the new created directory (new project directory) and issue a `vagrant up`

The new project will be created in the `project_slug` directory, passed as input to the cookiecutter comand.

## More

The core of the project is the cookiecutter.json file, that holds the main project config, and the Vagrantfile inside the template directory (_{{ cookiecutter.project_slug }}_), that holds the virtual machines config.

Besides Ansible, Vagrant and Virtualbox, although not required, the new project will expect some useful tooling like *direnv* and  *todo.sh*. Those can be easily cleaned/removed by deleting the *.envrc* file and *todo* directory.

## File cookiecutter.json

The file holds the following keys, that will be prompted when "cookiecutting" the project:

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

The vm suffix index for the last vm that wil be created (for example vm-**3**). Together with the `instance_index_start` parameter, it will determine the amount of vms. For example, with an `instance_index_start` of 0 and an `instance_index_end` of 2, three vms will be created.

Defaults to `2` (so two virtual machines will be created in the default config).

##### ip_prefix

The prefix for the IP address. The IP address for the machines will be generated using the instance start|end index and the prefix. So in the default confing it will be 192.168.4.11 for vm-1, 192.168.4.12 for vm-2 and so on.

Pay attention to possible IP adressess conflicts in the Vagrant private network.

Defaults to `192.168.56.1`.

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

##### ansible_bootstrap_role

The role that should be used to bootstrap ansible in the virtual machines.

It used to be hardcoded, but the original role (robertdebock.bootstrap) started breaking things (crucially) and the patches (issue + pull request) were not being taken care of. So it was changed to allow other roles.

Defaults to `frock81.bootstrap` (for now, plans to change as soon as upstream gets updated)
