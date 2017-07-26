#Key value pairs for variables declared in variables.tf
#If value not specified, default will be used
#If no default declared, terraform will error


awsregion = "us-east-1"

#VPC variables

#VPC CIDR block
cidr = "10.0.0.0/16"

vpc_name = "LicentaVPC"

#availability zone. should be list with all available zones in that region
subnet_avz = ["us-east-1a", "us-east-1b"]

public_subnet_cidr_block = ["10.0.1.0/24"]
private_subnet_cidr_block = ["10.0.10.0/24"]

ssh_user              = "centos"
ssh_public_key_name   = "terraform-ssh-key-patri" 

ssh_public_key_file   = "~/.ssh/id_rsa.pub"


#-- ports open on the NAT instance
##-- becase we will also have VPN, we also open '45654'
nat_inbound_ports     = "22,45654"

ansible_hosts_file  = "../ansible/hosts"
ansible_iptables_file = "../ansible/roles/nat/tasks/iptables.yml"
ec2_os = "CentOS Linux 7 x86_64"

