variable "ami" {
  default = "ami-04763b3055de4860b"
}
variable "key_name" {
  default = "test"
}
variable "subnet_id" {
  type    = string
}
variable "sg" {
}
variable "pemfile"{
  default = "test.pem"
}