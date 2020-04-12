output "lb_dns" {
    description = "This will be DNS name of the ALB"
    value = module.alb.lb_dns
}

output "pgdb_endpoint" {
    description = "The connection endpoint"
    value       = module.aurora-postgresql.pgdb_endpoint
}

output "jump_box" {
  description = "Jump host public IP address"
  value       = module.jumpbox.public-ip
}

output "private-ips" {
  value = module.java-app.private-ips
}
