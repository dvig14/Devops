data "template_file" "vagrantfile" {
  template = file("${path.module}/vagrantfile.tpl")

  vars = {
    vms_json = jsonencode(local.vms_with_absolute_paths)
  }
}

resource "local_file" "vagrantfile" {
  content  = data.template_file.vagrantfile.rendered
  filename = "${path.module}/../output/Vagrantfile"
}

resource "null_resource" "vagrant_up" {
  # First ensure vagrantfile is created as resources not linked 
  depends_on = [local_file.vagrantfile]

  provisioner "local-exec" {
    command = "vagrant ${var.vm_state} ${var.vm_name != "" ? var.vm_name : ""}"
    working_dir = "${path.module}/../output"
  }

  triggers = {
    vm_state = var.vm_state
    vm_name  = var.vm_name
  }
}

resource "null_resource" "vagrant_destroy" {
    
  depends_on = [null_resource.vagrant_up]

  provisioner "local-exec" {
    when = destroy
    command = "vagrant destroy ${var.vm_name != "" ? var.vm_name : ""} -f"
    working_dir = "${path.module}/../output" 
  }

  triggers = {
    vm_name  = var.vm_name
  }
}