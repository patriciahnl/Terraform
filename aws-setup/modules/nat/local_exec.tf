#Local execution file to render hosts file and execute ansible playbook

data "template_file" "hosts_file" {
  template = "${file("${path.module}/hosts.tpl")}"
}

resource "null_resource" "local_exec" {
  triggers { 
    template = "${data.template_file.hosts_file.rendered}" 
  }
  
  provisioner "local-exec" {
    command = "echo \"${data.template_file.hosts_file.rendered}\" > ${var.ansible_hosts_file}

  }
}


