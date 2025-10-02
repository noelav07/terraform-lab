resource "aws_instance" "module_example" {
  ami           = var.ami_id
  instance_type = var.instance_type

  tags = {
    Name = "Module_example"
  }
}