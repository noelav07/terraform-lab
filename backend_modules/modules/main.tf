module "s3_bucket" {
  source = "./modules/s3"
  bucketname = var.bucketname

}


module "module_ec2" { 
    source = "./modules/ec2-instance"
    ami_id = var.ami_id
    instance_type  = var.instance_type

}

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}

