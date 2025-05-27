# Terraform: Variables & Outputs

Understanding variables and outputs in Terraform helps make code reusable, maintainable, and scalable.

---

## Variables (`var`)

Variables help extract hardcoded values from your main configuration files and define them externally for reuse and flexibility.

**Why use variables?**
- Reuse code
- Centralize value definitions
- Easily change values (like AMI, instance type, region, tags)

**Example Structure**

**provider.tf**
```hcl
provider "aws" {
  region = var.REGION
}
```

**main.tf**
```hcl
resource "aws_instance" "server" {
  ami           = var.AMIS[var.REGION]
  instance_type = var.vm_size
}
```

**variables.tf**
```hcl
variable "REGION" {
  default = "us-west-1"
}

variable "AMIS" {
  type = map(string)
  default = {
    "us-west-1" = "ami-12345678"
    "us-west-2" = "ami-87654321"
  }
}

variable "vm_size" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}
```

##  `Passing Values to Variables`

**Using CLI**
```bash
terraform apply -var="vm_size=t3.micro"`
```

**Using `.tfvars` Files**
- Useful for managing multiple environments or automation.
- 2 ways 
`*.tfvars` file:
```hcl
vm_size = "t3.small"
REGION  = "us-west-2"
```

`custom name (prod.tfvars)`
```bash
terraform apply -var-file="prod.tfvars"
```

`automatic execute(terraform.tfvars)`
```bash
terraform apply
```

---

## Outputs

Outputs are used to extract information from created resources, like IP addresses or resource IDs.

**Example Output Block**
```hcl 
output "instance_ip_addr" {
  value = aws_instance.server.public_ip
}
```

**Syntax:**
`resourceType.resourceName.attributeName`

