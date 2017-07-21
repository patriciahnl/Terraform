[natinstance]
ansible_host=${aws_eip_association.eip_alloc_nat.public_ip}
ansible_connection=ssh
ansible_ssh_private_key_file=${var.private_key_file}

