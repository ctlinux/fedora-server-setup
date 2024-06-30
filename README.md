# fedora-server-setup

Provision basic Fedora server

Fedora bare-minimal server, packages installed afterwards.  Goal is to create auto-installation scripts and maintain with Ansible.

## Configuration management with _Ansible_

The playbook (`fedora-server-setup.yaml`) is a collection of tasks that confgiures a minimal Fedora server. The playbook reads the different variable - such as packages to install, and services to enable - from `fedora-server-vars.yaml`. Adding additional packages or services is as simple as adding a new line to the appropriate list in `fedora-server-vars.yaml`.

### Installing Ansible

Always install from pip:

```bash
pip install ansible
```

### Requirements

The playbook requires `community.general` and `ansible.posix` collections. Install them with:

```bash
ansible-galaxy collection install -r requirements.yml --upgrade
```

#### Variables

The following variables are defined in `fedora-server-vars.yaml`:

- `dnf_packages`: list of packages to install with `dnf`
- `dnf_groups`: list of groups to install with `dnf` (could be added under `dnf_packages` as well, but cleaner to separate packages and groups)
- `sys_services`: list of services to enable and start with `systemd`

Additionally the following variables are prompted for during the playbook execution:

- `target_host`: the host to configure with ansible. Hostname as defined in the inventory.
- `target_hostname`: the hostname to set on the target host.

### Running the playbook

Make sure that an inventory file is prepared either in an `ini` or a `yaml` format.

```bash
ansible-playbook -i inventory.ini fedora-server-setup.yaml
```

#### Overwriting variables

The play will read variables from `fedora-server-vars.yaml`. To overwrite a variable, use the `-e` flag on the cli (hierarchically cli passed variables will overwrite the ones defined in the file):

```bash
ansible-playbook -i inventory.ini fedora-server-setup.yaml -e "dnf_packages=[\"package1\", \"package2\"]"
```

## To Do

- [ ] Turn the playbook into a role
- [ ] Github Actions
  - for checking yaml syntax (yamllint)
  - for testing the playbook against a Fedora VM
