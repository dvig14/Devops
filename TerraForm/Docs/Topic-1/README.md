# Terraform Code Structure

This document provides an overview of the basic structure of Terraform configuration files (.tf) and explains key components such as providers, data sources, resources, and the difference between stateful and stateless infrastructure management.

--- 

## 📁 Terraform Code Structure

A typical Terraform configuration file is made up of the following blocks:

### 1. `Provider Block`

The provider block defines the infrastructure platform you want to interact with, such as AWS, Azure, or GitHub.

**Example:**
``` hcl
provider "aws" {
  region = "us-west-1"
}
```
> This tells Terraform to use AWS and deploy resources in the us-west-1 region.


### 2. `Data Source Block`

Data sources allow you to fetch and reference information from existing infrastructure. They are read-only and cannot be used to create or modify resources.

**Example:**
```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"] # Ubuntu official owner ID
}
```
> In this example, we’re dynamically fetching the latest Ubuntu AMI to use in an EC2 instance.


### 3. `Resource Block`

Resources are the fundamental building blocks of Terraform. They are used to define what infrastructure Terraform should create or manage.

**Example:**
```hcl
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "web_instance"
  }
}
```
> This creates an EC2 instance using the Ubuntu AMI fetched from the data source.

---

# 🧠 Stateful vs Stateless Infrastructure

## 🌐 Stateful Infrastructure

**Definition:** Tracks the current state of infrastructure.
**Terraform Behavior:** Stores infrastructure state in a file called terraform.tfstate.
**Benefits:**
1. Knows which resources already exist.
2. Applies only the changes needed (no duplication).
3. Prevents unnecessary re-creation of resources.


## ⚙️ Stateless Infrastructure

**Definition:** Does not retain any information about the existing state.
**Example:** Bash scripts or manual provisioning.
**Drawbacks:**
1. Re-runs entire scripts every time.
2. Cannot detect existing resources.
3. Prone to duplication or conflicts.

---

## 📌 Summary

**Concept	Description**

`provider`	  Specifies cloud/infrastructure platform
`data`	      Reads from existing infra (read-only)
`resource`	  Defines infrastructure to be created
`stateful`	  Maintains state and prevents duplication
`stateless`	  No state awareness, always re-runs