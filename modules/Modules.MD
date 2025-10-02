# Terraform Practice: Modules + Remote Backend (S3 + DynamoDB)

This repo is my practice ground for learning **Terraform modules** and configuring a **remote backend** using **S3** and **DynamoDB** for state locking.  

It includes:
- A custom **S3 module** (with versioning support).
- An **EC2 module**.
- Remote state stored in **S3**, with a **DynamoDB table** for state locking.

---

## What I Built

### 1. S3 Module
- Creates an S3 bucket.
- Enables versioning.
- Supports `force_destroy` to auto-delete all objects when destroying.

### 2. EC2 Module
- Creates a simple EC2 instance.
- Allows security group attachment.

### 3. Remote Backend
- Terraform state stored in an S3 bucket.
- DynamoDB table used for state locking.

---

##  Key Things to Remember

### 1. Module Blocks
- A `module` block can **only accept variables**, not resources.
```hcl
module "s3_bucket" {
  source     = "./modules/s3"
  bucketname = var.bucketname
  # ❌ Cannot declare resources like aws_s3_bucket_versioning here
}
```
> Resources (aws_s3_bucket_versioning, aws_instance, etc.) must be defined inside the module itself.

---

## 2. Remote Backend Gotchas
- Once you configure backend `"s3"`, Terraform uses **S3 + DynamoDB** for state and locking.  
- Terraform **cannot destroy its own backend while using it**.  
- To destroy backend resources, **migrate state back to local** first.

---

## 3. Migrating Remote State → Local
Comment out the backend block:

```hcl
# terraform {
#   backend "s3" {
#     bucket         = "my-tf-backend"
#     key            = "terraform.tfstate"
#     region         = "ap-south-1"
#     dynamodb_table = "terraform-lock"
#   }
# }
```

### Re-init and Migrate

Re-initialize Terraform and migrate state:

```bash
terraform init -migrate-state -lock=false
```

> Disable lock if DynamoDB is misconfigured or unavailable. Terraform now operates with local state.

### 4. Destroying Everything

1. Destroy all infrastructure while still using remote backend:
2. Migrate back to local state (see step above).
3. Finally, destroy backend resources (S3 + DynamoDB):
```bash
terraform destroy
```

### 5. S3 Bucket Deletion Issues

By default, Terraform **cannot delete a bucket** if it has objects or versioning enabled.

**Fixes:**

1. Add `force_destroy = true` in the bucket resource:

```hcl
resource "aws_s3_bucket" "backend" {
  bucket        = "my-backend"
  force_destroy = true
}

```

### Notes

- **Modules:** Keep resources inside modules; pass only variables in the module block.  
- **Remote Backend:** DynamoDB locking prevents concurrent state writes. Always migrate to local state before deleting backend infrastructure.  
- **Bucket Cleanup:** Use `force_destroy` or manually empty versioned buckets.  
- **Destroy Order:** Infrastructure first → migrate → backend last.
