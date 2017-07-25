#Calling nat module

module "nat" {
  source = "./modules/nat"

  number_of_nat_instances = 1
  nat_instance_ami = "${data.aws_ami.centos.image_id}"
  nat_instance_type = "t2.micro"
  subnet_id = "${join(",", aws_subnet.publicsubnet.*.id)}"
  private_cidr_block = "${join(",", aws_subnet.privatesubnet.*.cidr_block)}"
  inbound_ports = "${var.nat_inbound_ports}"
  key_name = "${aws_key_pair.local_key.key_name}"
  #-- assuming 'private key name' by removing the '.pub' extension
  private_key_file = "${replace(var.ssh_public_key_file, ".pub", "")}"
  sgs = "${aws_default_security_group.defaultsg.id},${aws_security_group.AllowICMP.id},${aws_security_group.DefaultPub.id}"
  ansible_hosts_file = "${var.ansible_hosts_file}"
  ansible_iptables_file = "${var.ansible_iptables_file}"


  
}
