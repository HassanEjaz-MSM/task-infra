output "private-ips" {
  value = "${data.aws_instances.servers.private_ips}"
}