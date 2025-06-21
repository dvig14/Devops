# Terraform + Vagrant Modular Setup with MinIO Backend

This project uses Terraform to dynamically generate a `Vagrantfile` from VM definitions, manage VM lifecycle (`up`, `halt`, `destroy`), and store the Terraform state remotely using **MinIO** as an S3-compatible backend.

---

## 📁 Project Structure

```
terraform/
├── backend.tf           # Remote backend configuration using MinIO
├── locals.tf            # Local values used across the config (e.g., processed VM info)
├── output.tf            # Terraform outputs (e.g., IP addresses)
├── resources.tf         # Resources: Vagrantfile, VM provisioning (via local-exec), and S3 bucket
├── terraform.tfvars     # Actual variable values for VMs (memory, IP, provision script, etc.)
├── vagrantfile.tpl      # Ruby ERB template to render Vagrantfile dynamically
├── variables.tf         # Input variable declarations
```

---

## 🪣 `backend.tf`: Configure Remote State Storage with MinIO

Before initializing Terraform, create a bucket using the **MinIO Console**:

### ✅ Step-by-Step:

1. **Access Console:**
   [http://localhost:9001](http://localhost:9001)

2. **Login with credentials:**

   * Username: `your-username`
   * Password: `your-password`

3. **Create Bucket:**

   * Bucket Name: `terraform-state`

```hcl
terraform {
  backend "s3" {
    bucket                      = "terraform-state"
    key                         = "terraform.tfstate"
    region                      = "us-east-1"
    endpoints                   = { s3 = "http://localhost:9000" }
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    use_path_style              = true
  }
}
```

### 💡 Why These Flags?

| Setting                       | Purpose                                                      |
| ----------------------------- | ------------------------------------------------------------ |
| `endpoints`                   | Use local MinIO instead of AWS which use IAM                 |
| `use_path_style`              | Required for MinIO (doesn't support subdomain-style buckets) |
| `skip_credentials_validation` | MinIO doesn't support AWS IAM                                |
| `skip_metadata_api_check`     | Prevents Terraform from looking for AWS EC2 metadata         |
| `skip_requesting_account_id`  | Avoids unnecessary AWS account checks                        |

---

## 🧩 `resources.tf`: Generate & Manage Vagrant VMs

### 1. 🧾 **Generate `Vagrantfile` from Template**

```hcl
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
```

* Template generates Vagrantfile using `vagrantfile.tpl` and `local.vms_with_absolute_paths`.
* Output saved to: `output/Vagrantfile`

---

### 2. 🔃 **Provision VMs (`up`, `halt`, etc.) using `null_resource` + `local-exec`**

```hcl
resource "null_resource" "vagrant_up" {
  depends_on = [local_file.vagrantfile]

  provisioner "local-exec" {
    command     = "vagrant ${var.vm_state} ${var.vm_name != "" ? var.vm_name : ""}"
    working_dir = "${path.module}/../output"
  }

  triggers = {
    vm_state = var.vm_state
    vm_name  = var.vm_name
  }
}
```

* **Working directory:** Runs command where the Vagrantfile is written ie output dir.
* **Trigger:** Ensures resource is recreated when `vm_state` or `vm_name` changes.
* **Depends_On:** Terraform doesn't link resources and if one related to other like here cant vagrant up before creating vagrantfile 
* **Lifecycle commands:**

  * `terraform apply` → `vagrant up` (default)
  * `terraform apply -var="vm_state=halt"` → `vagrant halt`
  * `terraform apply -var="vm_state=halt" -var="vm_name=app"` → `vagrant halt app`
  * `terraform apply -var="vm_state=up" -var="vm_name=app"` → `vagrant up app`

---

### 3. 🔥 **Destroy VM on `terraform destroy`**

```hcl
resource "null_resource" "vagrant_destroy" {
  depends_on = [null_resource.vagrant_up]

  provisioner "local-exec" {
    when        = destroy
    command     = "vagrant destroy ${var.vm_name != "" ? var.vm_name : ""} -f"
    working_dir = "${path.module}/../output"
  }

  triggers = {
    vm_name = var.vm_name
  }
}
```

* **`when = destroy`** ensures this only runs during `terraform destroy` as provisioners run only during creation.
* **Destroy all or specific VM:**

  * `terraform destroy` → `vagrant destroy -f`
  * `terraform destroy -var="vm_name=jenkins"` → `vagrant destroy jenkins -f`

---

## 📥 `variables.tf`: Input Variables

```hcl
variable "vm_state" {
  description = "Vagrant action: up, halt, reload"
  type        = string
  default     = "up"
}

variable "vm_name" {
  description = "VM name to operate on. Empty means all VMs."
  type        = string
  default     = ""
}
```

---

## 🚀 Example Usages

| Scenario                        | Command                                                   |
| ------------------------------- | --------------------------------------------------------- |
| Bring all VMs up (default)      | `terraform apply`                                         |
| Halt all VMs                    | `terraform apply -var="vm_state=halt"`                    |
| Halt specific VM (`app`)        | `terraform apply -var="vm_state=halt" -var="vm_name=app"` |
| Bring up specific VM (`app`)    | `terraform apply -var="vm_state=up" -var="vm_name=app"`   |
| Destroy all VMs                 | `terraform destroy`                                       |
| Destroy specific VM (`jenkins`) | `terraform destroy -var="vm_name=jenkins"`                |

---

## ✅ Why Use `null_resource` with Triggers?

* `null_resource` doesn’t track actual infrastructure.
* Without `triggers`, Terraform won’t re-run the provisioner even if variables like `vm_state` change.
* `triggers` force re-creation when relevant inputs change.
