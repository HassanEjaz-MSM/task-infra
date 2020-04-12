output "lb_dns" {
  value = aws_alb.alb.dns_name
}

output "target_group_arn" {
  value = aws_alb_target_group.alb_tg.arn
}