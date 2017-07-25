#Calling nat module

module "nat" {
  source = "modules/nat"

  number_of_nat_instances = 1
  nat_instance_ami = "${data.aws_ami.centos.image_id}"
  nat_instance_type = "t2.micro"
  subnet_id = "${join(",", aws_subnet.publicsubnet.*.id)}"
  
  #by using the aws_subnet resource will cause a circular dependency because the module is computed first
  #private_cidr_block = "${aws_subnet.privatesubnet.*.cidr_block}"

  private_cidr_block = "${var.private_subnet_cidr_block}"
  inbound_ports = "${var.nat_inbound_ports}"
  key_name = "${aws_key_pair.local_key.key_name}"
  
  #assuming 'private key name' by removing the '.pub' extension
  
  private_key_file = "${replace(var.ssh_public_key_file, ".pub", "")}"
  secgroups = "${aws_default_security_group.defaultsg.id},${aws_security_group.AllowICMP.id},${aws_security_group.DefaultPub.id}"
  ansible_hosts_file = "${var.ansible_hosts_file}"
  ansible_iptables_file = "${var.ansible_iptables_file}"
  nat_instance_name = "NATVPN"
  vpc_name = "${var.vpc_name}"
  vpc_id = "${aws_vpc.mainvpc.id}"
  


  
}
