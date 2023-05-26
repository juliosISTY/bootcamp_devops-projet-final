resource "aws_instance" "ec2_vm" {
  ami           = "ami-033b95fb8079dc481"
  instance_type = var.ins_type
  key_name      = var.ssh_key
  tags          = var.tag_name
  availability_zone = var.AZ

  security_groups = ["${var.sg_name}"]

  provisioner "local-exec" {
    command = "echo PUBLIC IP: ${var.public_ip} > /var/jenkins_home/workspace/ic-webapp/public_ip.txt"
  }

  root_block_device {
    delete_on_termination = true
  }
}
