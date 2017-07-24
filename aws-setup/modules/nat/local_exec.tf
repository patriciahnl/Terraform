#Local execution file to render hosts file and execute ansible playbook

data "template_file" "hosts_file" {
  template = "${file("${path.module}/hosts.tpl")}"
  
  #you only have access to the variables defined in the vars sectioni
  vars {
    public_ip = ${var.public_ip}
    private_key_file = ${var.private_key_file}
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

resource "null_resource" "local_exec_tasks" {
  triggers {
    template = "${data.template_file.nat_tasks.*.rendered}"
  }

  provisioner "local-exec" {
    #empty file
    command = "echo \"\" > ${var.nat_tasks_file}"
    
    #append each templated iptables rule
    command = "echo \"${data.template_file.nat_tasks.*.rendered}\" >> ${var.ansible_iptables_file}"
  }
 
  
}




