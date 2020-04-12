output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc_cidr"{
  value = "${aws_vpc.vpc.cidr_block}"
}

output "priv1" {
  value = "${aws_subnet.priv1_subnet.id}"
}

output "priv2" {
  value = "${aws_subnet.priv2_subnet.id}"
}

output "public_subnet" {
  value = "${aws_subnet.pub1_subnet.id}"
}

output "public2_subnet" {
  value = "${aws_subnet.pub2_subnet.id}"
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "private_route_table_ids" {
  value = "${aws_default_route_table.priv_rt.id}"
}

output "public_route_table_ids" {
  value = "${aws_route_table.public_rt.id}"
}
