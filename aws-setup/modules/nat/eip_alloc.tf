#Elastic IP allocation for NAT instance

resource "aws_eip" "nat_instance_eip" {
  instance = "${aws_instance.nat_instance.id}"
  vpc = true
}

#Allocate
resource "aws_eip_association" "eip_alloc_nat" {
  instance_id = "${aws_instance.nat_instance.id}"
  allocation_id = "${aws_eip.nat_instance_eip.id}"
}
