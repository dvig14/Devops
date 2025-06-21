variable "vms" {
  type = list(object({
    name   = string
    ip     = string
    memory = number
    path   = string
  }))
}

variable "vm_state" {
  type = string
  default = "up" # or "halt"
}

variable "vm_name" {
  type = string
  default = "" 
}