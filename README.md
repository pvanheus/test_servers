### Virtual servers setup

Virtual servers are created as per the config in `terraform/main.tf`. The number and passwords for the servers
are configured in `terraform/vars.tf` (see `terraform/vars.tf.example` for the syntax). Before deploying,
import the `openstack_networking_network_v2.masters_net_1`, `openstack_networking_subnet_v2.masters_net_1_sn_1` and
`openstack_compute_keypair_v2.pvhebmkey` using `terraform import`.

The output of the `terraform apply` command is a set of IP addresses that:

1. need to be added to the DNS (internal and external). If stored in a file with `<ip> <hostname>` on each line, a
   script for the internal DNS can be created with `terraform/make_dns_template.py`.
2. rules need to be added to the firewall forwarding ports to port 22 of each server.

Slurm is configured on each server using the ansible playbook in `ansible/hosts.yml`. Requirements are specified in
`ansible/requirements.yml` and can be installed with `ansible-galaxy role install -p roles -r requirments.yml`. The
`ansible/hosts` file should be configured as per the DNS config and then it can all be applied with `ansible-playbook hosts.yml`.

SARS-CoV-2 data (10 paired end samples from the SRP253798 collection), the reference genome (MN908947.3) were copied to
each machine (not via Ansible).