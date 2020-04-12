#-------------VPC----------------#
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr  
   tags = {
    Name = var.vpc_name
  }
}

#----------------Internet Gateway----------------#

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

#------------------EIP---------------------#


resource "aws_eip" "nat" {
  vpc = true
  depends_on                = [aws_internet_gateway.igw]
}

#----------------NAT Gateway--------------------#

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.pub1_subnet.id
  depends_on = [aws_internet_gateway.igw]
}

#-----------------------Subnets---------------------#

resource "aws_subnet" "priv1_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidrs["private1"]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "private1"
  }
}

resource "aws_subnet" "priv2_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidrs["private2"]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "private2"
  }
}

resource "aws_subnet" "pub1_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidrs["public1"]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "pub2_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidrs["public2"]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
}

#-------------------Route Tables--------------------#

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public_rt"
  }
}

resource "aws_default_route_table" "priv_rt" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = "priv_rt"
  }
}

#--------------------Subnet Associations------------------------#

resource "aws_route_table_association" "pub1_assoc" {
  subnet_id      = aws_subnet.pub1_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pub2_assoc" {
  subnet_id      = aws_subnet.pub2_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "priv1_assoc" {
  subnet_id      = aws_subnet.priv1_subnet.id
  route_table_id = aws_default_route_table.priv_rt.id
}

resource "aws_route_table_association" "priv2_assoc" {
  subnet_id      = aws_subnet.priv2_subnet.id
  route_table_id = aws_default_route_table.priv_rt.id
}

