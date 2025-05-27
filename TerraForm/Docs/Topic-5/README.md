## Terraform: Backend & Remote State Management

### 1. Purpose of Backend

* Stores the Terraform **state file** (`.tfstate`), which holds infrastructure information.
* By default, this file is stored **locally** (on your machine).
* Problem: Teams working on the same project need **shared** state.

---

### 2. Why Remote State?

* Local `.tfstate` file doesn't support team collaboration.
* Code can be pushed to GitHub, but state must also be shared.
* **Remote state** enables collaborative and safe Terraform usage.

---

### 3. S3 Backend Setup in AWS

Terraform can maintain the state file in an **S3 bucket**.

#### Steps:

1. **Create an S3 Bucket** in AWS.
2. **Create a backend config file** (e.g., `backend.tf`):

   ```hcl
   terraform {
     backend "s3" {
       bucket = "your-bucket-name"
       key    = "path/to/your/key"
       region = "your-region"
     }
   }
   ```
3. Run:

   * `terraform init`
   * `terraform plan`
   * `terraform apply`

---

### 4. Benefits of Remote State

* Multiple team members can work on the same infrastructure.
* Prevents **simultaneous conflicting updates**.
* Improves **security** (stores sensitive info remotely).
* Ensures **backup & recovery**.

---

### Common Backends 

- s3
- azurerm
- consul :  store state in hashicorp consul
- remote :  terraform cloud
- gcs    :  google cloud storage

---

### What is `Locking` (Concurrency Control)

Locking means 2 people can't write or modify anything simultaneously.

* **Without locking**: Causes duplicate resources, conflicts, deleted info.
* **With locking**:

  * When `terraform apply` is run, a **lock** is placed in the state.
  * Others must wait to get access.
  * Prevents simultaneous usage of state.
  * If one person run `terraform apply` and then next person try to do so then get msg or error that someone already using state.

#### Locking Storage:

* `S3` → Uses **DynamoDB** for locking.
* `Consul`, `Remote` → Built-in locking.

---

### Backup Options

* **S3**: Supports **versioning** (retrieve older versions).
* **Remote**: Automatic backups.
* **Consul**: Manual or snapshot-based backup.

---

### Ideal Use Cases

* **S3** → Ideal for **production/cloud** infrastructure.
* **Consul** → Ideal for **self-hosted/internal** tooling (more control).
* **Remote** → Best for **teams/CI-CD pipelines**.

---

