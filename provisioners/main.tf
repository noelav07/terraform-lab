resource "aws_vpc" "vpc1" {
  cidr_block = var.vpc_cidr
   enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "provisioner"
  }
  
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.subnet1_cidr
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.vpc1.id
  cidr_block              = var.subnet2_cidr
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
}



resource "aws_internet_gateway" "vpc1_igw" {
  vpc_id = aws_vpc.vpc1.id
}


resource "aws_route_table" "vpc1_rt" {
  vpc_id = aws_vpc.vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc1_igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.vpc1_rt.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.vpc1_rt.id
}



resource "aws_security_group" "vpc1_sg" {
  name   = "vpc1_sg"
  vpc_id = aws_vpc.vpc1.id

  ingress {
    description = "Allow All Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
 

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_key_pair" "deployer" {
  key_name   = "vpc1_key"
public_key = file("/root/.ssh/id_rsa.pub")
}



resource "aws_instance" "vpc_ec21" {
    

    ami = var.ami_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.vpc1_sg.id]
    subnet_id              = aws_subnet.sub1.id
    key_name = aws_key_pair.deployer.key_name

 connection {
    type        = "ssh"
    user        = "ec2-user"  # Replace with the appropriate username for your EC2 instance
    private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key
    host        = self.public_ip
  }


  provisioner "file" {
    source      = "index.html"  
    destination = "/home/ec2-user/index.html" 
      }


  provisioner "remote-exec" {
  inline = [
    "sudo dnf update -y",
    "sudo dnf install -y httpd",

    "sudo systemctl enable --now httpd && sudo systemctl restart httpd",
    "sudo cp -rvf /home/ec2-user/index.html /var/www/html"
  
  ]
  }


}


output "ec2_ip" {

    value = aws_instance.vpc_ec21.public_ip

}
output "ec2_dns" {

    value = aws_instance.vpc_ec21.public_dns
}