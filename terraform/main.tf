resource "openstack_compute_instance_v2" "test_servers" {
  count = var.instance_count
  name        = "test_server_${count.index}"
  flavor_name = "m1.medium"
  key_pair    = "pvhebmkey"
  image_name  = "ubuntu-18.04-server"

  network {
    name = "masters_net_1"
  }

  # does not work with ID
  # security_groups = ["b2fa5f39-2b48-421d-848b-88aea8a2121c", openstack_compute_secgroup_v2.test_server_secgroup.id]
  security_groups = [ "default", openstack_compute_secgroup_v2.test_server_secgroup.name ]

  user_data = "#cloud-config\npassword: ${element(var.passwords, count.index)}\nchpasswd: { expire: False }\nssh_pwauth: True"
}

output "g_m2_floatingip_address" {
  value = openstack_compute_floatingip_associate_v2.t_floatingip_associate.*.floating_ip
}

resource "openstack_compute_keypair_v2" "pvhebmkey" {
  name = "pvhebmkey"
}

resource "openstack_compute_floatingip_v2" "t_floatingip" {
  count = var.instance_count
  pool = "public1"
}

resource "openstack_compute_floatingip_associate_v2" "t_floatingip_associate" {
  count = var.instance_count

  floating_ip = element(openstack_compute_floatingip_v2.t_floatingip.*.address, count.index)
  instance_id = element(openstack_compute_instance_v2.test_servers.*.id, count.index)
}

resource "openstack_compute_secgroup_v2" "test_server_secgroup" {
  name = "test_server_secgroup"
  description = "public server security group: SSH and HTTP/S"

  # rule {
  #   from_port = 0
  #   to_port   = 0
  #   ip_protocol = "tcp"
  #   self      = true
  # }

  # rule {
  #   from_port = -1
  #   to_port = -1
  #   ip_protocol = "icmp"
  #   cidr = "0.0.0.0/0"
  # }

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 443
    to_port     = 443
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_networking_network_v2" "masters_net_1" {
  name = "masters_net_1"
}

resource "openstack_networking_subnet_v2" "masters_net_1_sn_1" {
  name       = "masters_net_1_sn_1"
  network_id = openstack_networking_network_v2.masters_net_1.id
  cidr       = "192.168.50.0/24"
  allocation_pool {
    start = "192.168.50.50"
    end = "192.168.50.100"
  }
  dns_nameservers = ["192.168.2.75", "192.168.2.8"]
  ip_version = 4
}
