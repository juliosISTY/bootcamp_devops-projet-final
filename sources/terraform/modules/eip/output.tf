output "eip_id" {
  value = aws_eip.lb.id
}
output "eip_public_ip" {
  value = aws_eip.lb.public_ip
}
