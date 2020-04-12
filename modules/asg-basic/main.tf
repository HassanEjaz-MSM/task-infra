resource "aws_launch_configuration" "lc" {
  image_id                    = var.image_id
  instance_type               = var.instance_type
  security_groups             = var.security_groups
  associate_public_ip_address = false
  key_name                    = var.key_name
  lifecycle {
    create_before_destroy     = true
  }
  enable_monitoring           = false
  user_data                   = data.template_file.userdata.rendered
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration        = aws_launch_configuration.lc.id
  max_size                    = var.max_size
  min_size                    = var.min_size
  vpc_zone_identifier         = var.vpc_zone_identifier 
  target_group_arns           = var.tg_arn
  metrics_granularity         = "1Minute"
  enabled_metrics             = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
    
  tag {
    key                       = "foo"
    value                     = "bar"
    propagate_at_launch       = true
  }
}

data "template_file" "userdata" {
  template                    = "${file("${path.module}/userdata.tpl")}"
  vars = {
  db                          = var.db_host
  }
}

data "aws_instances" "servers" {
  depends_on = [ aws_autoscaling_group.asg ]

  instance_tags = {
    foo                       = "bar"
  }
}