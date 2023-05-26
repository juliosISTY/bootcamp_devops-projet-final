variable "ins_type" {
  default = "t2.nano"
  type    = string
}
variable "tag_name" {
  default = {
    Name = "ec2-exemple"
  }
  type = map(any)
}
variable "sg_name" {
  default = "exemple-sg"
  type    = string
}
variable "public_ip" {
  default = "NULL"
  type    = string
}
variable "AZ" {
  default = "us-east-1b"
  type    = string
}
variable "ssh_key" {
  type    = string
  default = "devops"
}
variable "project_name" {
  type    = string
  default = "projet_final"
}
