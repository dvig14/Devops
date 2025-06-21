# Project Setup Guide: Terraform + Vagrant + MinIO

This project uses **Terraform** to manage virtual machines via **Vagrant**, with **MinIO** acting as a backend for storing Terraform state files.

---

## 📂 Project Structure Overview  

```
Project/
├── minio-server-S3/                  # MinIO setup using Vagrant and provisioning script 
│   ├── explain-setup.md              # Detailed provisioning explanation
│   ├── setup-minio.sh                # Script to provision and start MinIO as a systemd service
│   ├── Vagrantfile                   # Vagrant configuration for MinIO VM
├── output/                           # Add content to Vagrantfile after applying terraform.Created using template
│   └── Vagrantfile                   
├── provision/                        # Provisioning scripts (e.g., Jenkins, Nginx)
│   ├── install-jenkins.sh
│   └── setup-nginx.sh
├── terraform/                        # Terraform configuration files for provisioning VMs
|   ├── backend.tf                    # Create s3-bucket to store terraform.tfstate file remotely on minio server
|   ├── explain-teraStruc.md          # Documentation explaining the Terraform structure and usage
|   ├── locals.tf                     # Used to store helper/intermediate values not input values like var.*
|   ├── output.tf                     # Defines output values (e.g., VM IPs) from Terraform resources
|   ├── resources.tf                  # resources: generates Vagrantfile, manages VMs via local-exec, and S3-bucket
|   ├── terraform.tfvars              # Variable values for VM definitions (name, IP, memory, provision script)
|   ├── vagrantfile.tpl               # Ruby template for generating a Vagrantfile from VM variables
|   ├── variables.tf                  # Input variable definitions 
├── .gitignore                        # used to hide (.env, minio-server-S3/.vagrant/, terrform/terraform.tfstate)
└── README.md                         # Project documentation
```

---

## 🔐 Prerequisites

Before initializing Terraform, ensure that the **MinIO server is running**, as it is used for remote state management.

---

## 🚀 Step 1: Start MinIO Server

Navigate to the MinIO setup directory and bring up the VM. Before running `vagrant up`, export environment variables so the provision script can access them:

```bash
cd minio-server-S3
source ../.env
vagrant up
```

* This uses the `Vagrantfile` and is **automatically provisioned** using `setup-minio.sh`.
* It installs MinIO, configures it as a `systemd` service, and starts it with credentials from a `.env` file.
* Avoid writing secrets directly into `Vagrantfile` or the script. This approach keeps credentials separate and secure.

📘 To understand the provisioning in detail, refer to:
👉 [explain-setup](./minio-server-S3/README.md)

---

## ⚙️ Step 2: Initialize Terraform

Once the MinIO server is up and running, navigate to the Terraform directory:

```bash
cd terraform
source ../.env
terraform init
terraform plan
terraform apply
```

* Terraform uses the MinIO S3-compatible service as a **remote backend** for `terraform.tfstate` files.
* VM creation, halting, and destruction are handled via `local-exec` provisioners that execute `vagrant` commands.
* If want to run this then first remove content from `output/Vagrantfile` as it written automatically using template

📘 For a full breakdown of Terraform configurations:
👉 [explain-teraStruc](./terraform/README.md)

