variable "vpc_cidr" {
  type    = string
  default = "10.68.2.0/24"
}
variable "vpc_name" {
  type    = string
  default = "test-vpc"
}

data "aws_availability_zones" "available" {}

variable "cidrs" {
  type = map(string)

  default = {
    public1  = "10.68.2.0/27"
    public2  = "10.68.2.64/27"
    private1 = "10.68.2.128/27"
    private2 = "10.68.2.160/27"
  }
}
