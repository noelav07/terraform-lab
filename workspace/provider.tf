terraform {
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"

    }
  }


}

provider "aws" {

  region = "var.region"
  alias  = "mumbai"

 default_tags {
   tags = {
     Project     = "VPC_Terraform"
   }
 }
}

