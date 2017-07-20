#AWS VPC provisioning
#Scenario: VPC with public and private subnets

resource "aws_vpc" "mainvpc" {
  cidr_block = "${var.cidr}"
  enable_dns_support = "${var.enable_dns_support}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  lifecycle {
    #ensure the resource is created before destroyed
    create_before_destroy = true
  }
  tags = "${merge(var.vpc_resource_tags, map("Name", var.vpc_name))}"
}

#PUBLIC SUBNET CONFIGURATION
#Internet gateway for public subnet

resource "aws_internet_gateway" "igwpublicsubnet" {
  #resource.name.attribute
  #check attributes list for each type of resource

  vpc_id = "${aws_vpc.mainvpc.id}"
  tags = "${merge(var.vpc_resource_tags, map("VPC", var.vpc_name))}"
}

#Public subnet resource
resource "aws_subnet" "publicsubnet" {
  vpc_id = "${aws_vpc.mainvpc.id}"
  cidr_block = "${element(var.public_subnet_cidr_block, count.index)}"
  availability_zone = "${element(var.subnet_avz, count.index)}"
  tags = "${merge(var.vpc_resource_tags, map("VPC", var.vpc_name))}"
  #must be a list in order to use length
  count = "${length(var.public_subnet_cidr_block)}"
  lifecycle {
    create_before_destroy = true
  }
 
}

#Create Public route table
resource "aws_route_table" "publicroute" {
  vpc_id = "${aws_vpc.mainvpc.id}"
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igwpublicsubnet.id}"
  }
  
  tags = "${merge(var.vpc_resource_tags, map("VPC", var.vpc_name), map("Name", "Public Subnet Route"))}"
  lifecycle { create_before_destroy = true }

}

#Associate public route table to public subnet
resource "aws_route_table_association" "publicrouteassoc" {
  count = "${length(var.public_subnet_cidr_block)}"
  #for each subnet
  subnet_id = "${element(aws_subnet.publicsubnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.publicroute.id}"
}

#PRIVATE SUBNET CONFIGURATION
#Private subnet
resource "aws_subnet" "privatesubnet" {
  vpc_id = "${aws_vpc.mainvpc.id}"
  cidr_block = "${element(var.private_subnet_cidr_block, count.index)}"
  availability_zone = "${element(var.subnet_avz, count.index)}"
  tags = "${merge(var.vpc_resource_tags, map("VPC", var.vpc_name))}"
  count = "${length(var.private_subnet_cidr_block)}"
  lifecycle {
    create_before_destroy = true
  }
}

#Route table for private subnet. Route towards 0.0.0.0/0 through instance performing NAT

resource "aws_route_table" "privateroute" {
  vpc_id = "${aws_vpc.mainvpc.id}"
  
  route {
    cidr_block = "0.0.0.0/0"
    instance_id = "${module.nat.instance_id}"
  }
  
  tags = "${merge(var.vpc_resource_tags, map("VPC", var.vpc_name), map("Name", "Private Subnet Route"))}"
  lifecycle { create_before_destroy = true }
}
#Associate route to private subnet
resource "aws_route_table_association" "privaterouteassoc" {
  count = "${length(var.private_subnet_cidr_block)}"
  subnet_id = "${element(aws_subnet.privatesubnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.privateroute.id}"
  lifecycle { create_before_destroy = true }
}



