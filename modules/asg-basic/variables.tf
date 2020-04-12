variable "image_id" {
  type    = string
  default = "ami-09a5b0b7edf08843d"
}

variable "instance_type" {
}

variable "max_size" {
  default = "1"
}

variable "min_size" {
  default = "1"
}

variable "eni_ips" {
  default = "false"
}

variable "security_groups" {
  type = list(string)
}

variable "vpc_zone_identifier" {
  type = list(string)
}

variable "key_name" {
  default = "test"
}

variable "tg_arn" {
}
variable "db_host" {
  
}
