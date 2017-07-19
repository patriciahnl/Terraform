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
  tags = "${merge(var.vpc_resource_tags, map("Name", var.vpc_name)}"
}


