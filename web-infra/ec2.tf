resource "aws_key_pair" "deployer" {
  key_name   = "vpc1_key"
  public_key = " "
}


resource "aws_instance" "vpc_ec21" {
    

    ami = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.vpc1_sg.id]
    subnet_id              = aws_subnet.sub1.id
    # user_data_base64        = base64encode(file("webserver.sh"))
    key_name = aws_key_pair.deployer.key_name
}



resource "aws_instance" "vpc_ec22" {

    ami = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.vpc1_sg.id]
    subnet_id              = aws_subnet.sub2.id
    # user_data_base64        = base64encode(file("webserver.sh"))
    key_name = aws_key_pair.deployer.key_name

}




