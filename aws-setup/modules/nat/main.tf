#Creates instance that will serve as NAT gateway using Ansible
#Makes sure Ansible is installed on that instance

#For each public subnet there must be an Internet Gateway, either AWS provided, either an instance serving NAT function
#If choosing the second method, this type of instance must be created for each public subnet created
# => Loop through  existent subnet ids

resource "aws_instance" "nat-instance" {
  
  count = "${var.number_of_nat_instances}" 

  #Required
  ami = "${var.nat_instance_ami}"
  instance_type = "${var.nat_instance_type}"
  
  #Optional arguments
  subnet_id = "${element(split(",", var.subnet_id), count.index)}"
  key_name = "${var.key_name}"
  
  vpc_security_group_ids = [ "${split(",", var.secgroups)}" ]

  source_dest_check = false
  
  root_block_device {
    volume_type = "gp2"
    volume_size = "${var.root_volume_size}"
    delete_on_termination = true
  }
  

  tags = "${merge(map("VPC", var.vpc_name), map("Name", var.nat_instance_name))}"
}


