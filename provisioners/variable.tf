variable "vpc_cidr" {

    description = "CIDR for VPC"
    type = string
}


variable "subnet1_cidr" {

    description = "CIDR for sub1"
    type = string
}

variable "subnet2_cidr" {

    description = "CIDR for sub2"
    type = string
}




variable "ami_id" {

description = "ubuntu_22"
type = string

}


variable "instance_type" {

description = "defined instance type"
type = string

}