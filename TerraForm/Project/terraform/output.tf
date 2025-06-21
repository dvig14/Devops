output "app_server_ip"{
   value = [for vm in var.vms : vm.ip if vm.name == "app"]
}

output "jenkins_server_ip"{
   value = [for vm in var.vms : vm.ip if vm.name == "jenkins"]
}