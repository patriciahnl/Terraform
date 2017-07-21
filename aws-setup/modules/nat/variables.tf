#Description, type and default for variables used in NAT module
#Declared in order of appearance


variable "number_of_nat_instances" {
  description = "Number of NAT instances to start"
  default = 1
}

variable "nat_instance_ami" {
  description = "AMI ID used for NAT instance"
}

variable "nat_instance_type" {
  description = "Amazon Instance type used for NAT instance"
}

variable "subnet_id" {
  description  = "Subnet ID for instance IP alloc"
}

variable "key_name" {
  description = "AWS SSH key name used for instance provisioning"
}

variable "secgroups" {
  description = "Security group IDs that will be assiged to instance"
}

variable "root_volume_size" {
  description  = "Size of root volume attached to the instance"
  default = 8
}

variable "nat_instance_name" {
  description  = "Name TAG of NAT instance"
}

variable "inbound_ports" {
  description = "Comma separated list of ports that will be opened on the public facing IP of the NAT instance" 
  default = "22,443"
}

variable "ansible_hosts_file" {
  description = "Path towards ansible hosts file"
}

