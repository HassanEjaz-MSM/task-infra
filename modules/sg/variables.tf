variable "tcp_ports" {
  default = "default_null"
}

variable "udp_ports" {
  default = "default_null"
}

variable "cidrs" {
  type = list
}

variable "security_group_name" {}

variable "vpc_id" {}