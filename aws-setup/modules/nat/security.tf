#Security groups
#Configure inbound/outbound access for NAT instance

resource "aws_security_group" "natsecgroup" {
  vpc_id = "${var.vpc_id}"
  description = "Default security group for NAT instance"
  tags = "${merge(map("Provisioner", "Terraform"), map("VPC", var.vpc_name), map("Name", "Default SG NAT instance"))}"
  
}

resource "aws_security_group_rule" "nat_rule" {
  count = "${length(split(",",var.inbound_ports))}"
  type = "ingress"
  from_port = "${element(split(",", var.inbound_ports), count.index)}"
  to_port = "${element(split(",", var.inbound_ports), count.index)}"
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.natsecgroup.id}"

}
