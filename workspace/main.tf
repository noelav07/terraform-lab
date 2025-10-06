module "module_ec2" { 
    source = "./modules/ec2-instance"
    ami_id = var.ami_id
    instance_type  = var.instance_type
    tags = merge(var.tags, { Name = terraform.workspace })
}

