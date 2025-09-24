provider "aws"{
    region = var.region-1

}

resource "aws_instance" "variable_1"{

    ami = var.ami
    instance_type=var.instance_type
    tags={

        Name=var.tagname
    }

}