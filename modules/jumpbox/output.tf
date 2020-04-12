output "public-ip" {
  value = aws_instance.jumpbox.public_ip
}

output "key_name" {
  value = var.key_name
}
