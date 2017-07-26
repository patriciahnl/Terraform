#Local execution file to render hosts file and execute ansible playbook

data "template_file" "hosts_file" {
  template = "${file("${path.module}/hosts.tpl")}"
  
  #you only have access to the variables defined in the vars sectioni
  
  vars {
    #the ip allocated to the nat instance
    public_ip = "${aws_eip_association.eip_alloc_nat.public_ip}"
    private_key_file = "${var.private_key_file}"
  }
}


#for each value of the list, there will be a rendered template

data "template_file" "nat_tasks" {
  template = "${file("${path.module}/nat_tasks.tpl")}"

  vars {
    network_addr = "${element(var.private_cidr_block, count.index)}" 
  }
  count = "${length(var.private_cidr_block)}" 
}

#provision ansible hosts file

resource "null_resource" "local_exec_hosts" {
  triggers { 
    template = "${data.template_file.hosts_file.rendered}" 
  }
  
  provisioner "local-exec" {
    command = "echo \"${data.template_file.hosts_file.rendered}\" > ${var.ansible_hosts_file}"

  }
}


#provision nat role, main tasks file
#It is neccesarry to add a rule for each subnet because the iptables Ansible module
#deals only with individual rules. We cannot chain a list of network addresses. 

resource "null_resource" "local_exec_tasks" {
  triggers {
    template = "${join(",", data.template_file.nat_tasks.*.rendered)}"
    #association_ip_address = "${aws_eip_association.eip_alloc_nat.id}"
  }

  provisioner "local-exec" {
    #empty file
    command = "echo \"\" > ${var.ansible_iptables_file}"
    
    #append each templated iptables rule
    command = "echo \"${element(data.template_file.nat_tasks.*.rendered, count.index)}\" >> ${var.ansible_iptables_file}"
    #command = "ansible-playbook -i ~/licenta/ansible/hosts ~/licenta/ansible/playbook.yml"
  }
 
  count = "${length(var.private_cidr_block)}"
}


resource "null_resource" "ansible_provisioning" {
  #wait until ip is associated
  triggers {
    association_ip_address = "${aws_eip_association.eip_alloc_nat.id}"
  }
  
  #execute remote exec to make sure instance is in a "ready" state
  #unlike ansible, remote exec loops until ssh is available
  
  provisioner "remote-exec" {
    script = "scripts/wait_for_instance.sh"
    
    connection {
      host = "${aws_eip.nat_instance_eip.public_ip}"
      user = "centos"
      timeout = "30s"
      private_key = "${file(var.private_key_file)}"
    }
  }
 
  provisioner "local-exec" {
    command = "ansible-playbook -i ~/licenta/ansible/hosts ~/licenta/ansible/playbook.yml"
  }
  
}




