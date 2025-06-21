locals {
  vms_with_absolute_paths = [
    for vm in var.vms : merge(vm,{
      path = "${path.module}/${vm.path}"
    })
  ]
}