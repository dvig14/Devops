# Terraform Commands: init, plan, apply, destroy

This document explains the core Terraform workflow commands—`init`, `plan`, `apply`, and `destroy`—and how they help manage infrastructure as code efficiently. It also includes information about initialization and files Terraform creates during execution.

---

## 🚀 Terraform Workflow Overview

### 1. `terraform init`

Initializes the working directory for Terraform.

**Purpose:**
- Downloads required provider plugins.
- Prepares the directory for other Terraform commands.

**Files Created:**

| File/Folder             | Description                                 |
|-------------------------|---------------------------------------------|
| `.terraform/`           | Stores provider binaries and modules.       |
| `.terraform.lock.hcl`   | Locks provider versions for consistency.    |
| `terraform.tfstate`     | Tracks the current state of infrastructure. |

**Example:**
```bash
terraform init 
```

---

### 2. `terraform plan`

Generates and shows an execution plan for reaching the desired state described in your .tf files without making any actual changes.

**Purpose:**
- Review what Terraform intends to change (add, update, destroy).
- Verify correctness before actual deployment.

**Example:**
```bash
terraform plan
```

---

### 3. `terraform apply`

Applies the changes required to reach the desired state of the configuration.

**Purpose:**
- Executes the plan generated by terraform plan.
- Makes real changes to cloud infrastructure.

**Example:**
```bash
terraform apply
```

`With Auto-Approval:`
```bash
terraform apply -auto-approve
```
> Skips the manual confirmation step.

---

### 4. `terraform destroy`

Destroys all infrastructure managed by Terraform. It is used to clean up resources.

**Purpose:**
- Deletes all resources defined in the state.
- Useful when tearing down environments (e.g., dev, staging).

**Example:**
```bash
terraform destroy
```

`With Auto-Approval:`
```bash
terraform destroy -auto-approve
```

---

### `🧠 Summary`

**Command Description**

|      `init`     |	    Initializes Terraform project and installs providers
|      `plan`     |     Shows what Terraform will do (no changes applied)
|     `apply`     |	    Executes changes to reach desired state
|    `destroy`    |	    Destroys all Terraform-managed infrastructure
| `-auto-approve` |	    Skips confirmation for apply and destroy



