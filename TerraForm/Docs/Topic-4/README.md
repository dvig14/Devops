# Terraform Provisioners

This document explains how to use Terraform provisioners to perform post-deployment tasks such as pushing and executing scripts on a provisioned resource (e.g., an AWS EC2 instance).

---

## What are Provisioners?

Provisioners in Terraform allow you to execute scripts or commands on a local or remote machine as part of the resource creation process.

> **Note:**  
> Terraform can execute these scripts but cannot manage their state after execution. It’s better to use dedicated configuration management tools like Ansible, but provisioners can be helpful for bootstrapping or quick tasks.

---

## 1. Using `file` Provisioner

The `file` provisioner is used to upload a local file (e.g., a shell script) to the remote machine.

**Example Steps:**

- Create a script: `postinst.sh`
- Upload the script:

```hcl
resource "aws_instance" "web" {
  # ... your EC2 config ...

  provisioner "file" {
    source      = "postinst.sh"
    destination = "/tmp/postinst.sh"
  }
}
```
> Ensure the destination folder exists; otherwise, it will throw an error.

---

## 2. Using `remote-exec` Provisioner

The remote-exec provisioner is used to execute commands on the remote machine using SSH.

**Example:**
```hcl
resource "aws_instance" "web" {
  # ... your EC2 config ...

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("<path-to-private-key>")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update",
      "chmod +x /tmp/postinst.sh",
      "sudo /tmp/postinst.sh"
    ]
  }
}
```
> This provisioner connects via SSH using a private key, uploads a file with `file`, and then executes it remotely.

---

## 3. Using `local-exec` Provisioner

If you want to save outputs (like public IP) to a file, use a `local-exec` provisioner.

**Example**
```hcl 
resource "aws_instance" "server" {
  ami           = var.AMIS[var.REGION]
  instance_type = var.vm_size

  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> public-ip.txt"
  }
}
```
> This creates public-ip.txt with the public IP of the instance.

---

## 4. Tips
- Use /tmp or other always-accessible directories for file uploads.
- Terraform can't track whether a script executed successfully or if its effects are still valid.
