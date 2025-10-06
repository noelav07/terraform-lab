## Terraform Workspace: Overview, Benefits, and This Setup

### What is a Terraform workspace?
Terraform workspaces provide separate state instances within the same configuration. Each workspace (for example, `default`, `dev`, `qa`, `prod`) uses the exact same code but keeps an isolated state file, allowing you to provision logically separate environments without duplicating configuration.

Key points:
- A workspace is a named state instance in the same backend.
- The active workspace is accessible in code via `terraform.workspace`.
- Switching workspaces changes which state file Terraform reads and writes.

Common commands:
```bash
terraform workspace list
terraform workspace new dev
terraform workspace select dev
```

### Why are workspaces helpful?
- Environment isolation: Safely manage `dev`/`test`/`prod` with the same code.
- Reduced duplication: One configuration, many environments.
- Lower risk: Changes in one workspace do not affect the state of another.
- Naming/scoping: You can feed the workspace name into resource names or tags to make environments discoverable.

### This repository: structure and purpose
This `workspace` folder provisions an AWS EC2 instance using a local module. It demonstrates how to:
- Centralize provider requirements.
- Pass variables like AMI and instance type.
- Apply a dynamic tag based on the current workspace.

Directory layout (simplified):
- `main.tf`: Calls the EC2 module and merges dynamic tags.
- `provider.tf`: Declares AWS provider (v6) and default tags.
- `variable.tf`: Declares inputs (`ami_id`, `instance_type`, `tags`).
- `modules/ec2-instance`: Local module creating the EC2 instance.

Code references:
```1:6:c:\Users\conta\terraform-lab\workspace\main.tf
module "module_ec2" { 
    source = "./modules/ec2-instance"
    ami_id = var.ami_id
    instance_type  = var.instance_type
    tags = merge(var.tags, { Name = terraform.workspace })
}
```

```1:6:c:\Users\conta\terraform-lab\workspace\modules\ec2-instance\main.tf
resource "aws_instance" "ws" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = merge(var.tags, { Name = terraform.workspace })

}
```

### Emphasis: the dynamic tag using terraform.workspace
This setup injects the active workspace name into resource tags to make each environment easy to identify in AWS.

- In root module and EC2 module, tags are merged with `{ Name = terraform.workspace }`.
- This means when you `terraform workspace select dev`, your instance will carry a `Name = dev` tag; for `prod`, it will be `Name = prod`.

Benefits of this pattern:
- Immediate environment visibility in the AWS console and cost tools.
- Simplifies filtering, search, and IAM/tag-based policies.
- Reduces manual tag drift—always consistent with the selected workspace.

### Inputs
- `ami_id` (string): AMI to use for the instance.
- `instance_type` (string): EC2 instance type.
- `tags` (map(string), optional): Baseline tags to merge with the dynamic Name tag.

### Provider
This workspace pins the AWS provider to `~> 6.0` and sets default tags at the provider level.

```14:24:c:\Users\conta\terraform-lab\workspace\provider.tf
provider "aws" {

  region = "var.region"
  alias  = "mumbai"

 default_tags {
   tags = {
     Project     = "VPC_Terraform"
   }
 }
}
```

Note: Adjust the provider `region` input and any aliases according to your environment.

### Usage
1) Initialize:
```bash
terraform init
```

2) Create/select a workspace (example: dev):
```bash
terraform workspace new dev || terraform workspace select dev
```

3) Provide variables and plan/apply:
```bash
terraform plan -var "ami_id=ami-xxxxxxxx" -var "instance_type=t3.micro" -var 'tags={"Owner"="you","Env"="dev"}'
terraform apply -auto-approve -var "ami_id=ami-xxxxxxxx" -var "instance_type=t3.micro" -var 'tags={"Owner"="you","Env"="dev"}'
```

4) Switch environments:
```bash
terraform workspace select prod
terraform apply -auto-approve -var "ami_id=ami-yyyyyyyy" -var "instance_type=t3.small" -var 'tags={"Owner"="you","Env"="prod"}'
```

After switching, the `Name` tag updates automatically to the active workspace.

