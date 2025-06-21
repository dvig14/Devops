vms = [
    {
      name   = "app"
      ip     = "192.168.56.11"
      memory = 1024
      path   = "../provision/setup-nginx.sh"
    },
    {
      name   = "jenkins"
      ip     = "192.168.56.13"
      memory = 2048
      path   = "../provision/install-jenkins.sh"
    }
  ]