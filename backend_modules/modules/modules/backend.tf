# terraform {
#   backend "s3" {
#     bucket         = "terraformbackendnoelav" 
#     key            = "noel/terraform.tfstate"
#     region         = "ap-south-1"
#     encrypt        = true
#     dynamodb_table = "terraform-lock"
#   }

# }