#Security stuff: keys creation, sec groups, acl

#Create SSH key
resource "aws_key_pair" "local_key" {
  key_name = "${var.ssh_public_key_name}"
  public_key = "${file(var.ssh_public_key_file)}"
}

#Default security group
resource "aws_default_security_group" "defaultsg" {
  vpc_id = "${aws_vpc.mainvpc.id}" 
  
  #allow inside traffic between the resource with this sec
  #group attached
  
  ingress {
    protocol = -1
    self = true
    from_port = 0
    to_port = 0
  }

  #allow outside traffic
  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = "${merge(var.vpc_resource_tags, map("VPC", var.vpc_name))}"
  
}

#Other user defined security groups
#-- Security Groups
resource "aws_security_group" "AllowICMP" {
  vpc_id      = "${aws_vpc.mainvpc.id}"
  description = "Allow all ICMP traffic"

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.vpc_resource_tags, map("VPC", var.vpc_name))}"
}

resource "aws_security_group" "DefaultPub" {
  vpc_id      = "${aws_vpc.mainvpc.id}"
  description = "Default VPC security group for public facing IPs"

  # TCP access
  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["194.126.146.0/24", "78.96.0.0/16"]
  }

  # HTTP access from anywhere
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#  # Outbound acces to anywhere
#  egress {
#    from_port = 0
#    to_port = 0
#    protocol = "-1"
#    cidr_blocks = ["0.0.0.0/0"]
#  }
#
  tags = "${merge(var.vpc_resource_tags, map("VPC", var.vpc_name))}"
}

resource "aws_security_group" "DefaultPrv" {
  vpc_id      = "${aws_vpc.mainvpc.id}"
  description = "Default VPC security group for private IPs"

  # Permit access from the VMs that resides in Public Subnet
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = ["${aws_security_group.DefaultPub.id}"]
  }

  # Outbound acces to anywhere
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${merge(var.vpc_resource_tags, map("VPC", var.vpc_name))}"
}



