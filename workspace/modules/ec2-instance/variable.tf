variable "ami_id" {

description = "ubuntu_22"
type = string

}


variable "instance_type" {

description = "defined instance type"
type = string

}

variable "tags" {
  type    = map(string)
  default = {}
}
