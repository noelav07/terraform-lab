resource "aws_instance" "ws" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = merge(var.tags, { Name = terraform.workspace })

}

