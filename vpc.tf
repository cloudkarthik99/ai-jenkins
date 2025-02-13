
resource "aws_vpc" "jenkins_vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = merge(var.common_tags, {
    Name = "jenkins-vpc"
  })
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.jenkins_vpc.id
  cidr_block = var.public_subnet_1
  availability_zone = "eu-central-1a"

  tags = merge(var.common_tags, {
    Name = "jenkins-public-subnet-1"
  })
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id = aws_vpc.jenkins_vpc.id
  cidr_block = var.public_subnet_2
  availability_zone = "eu-central-1b"

  tags = merge(var.common_tags, {
    Name = "jenkins-public-subnet-2"
  })
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.jenkins_vpc.id
  cidr_block = var.private_subnet
  availability_zone = "eu-central-1a"
  
  tags = merge(var.common_tags, {
    Name = "jenkins-private-subnet"
  })
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = merge(var.common_tags, {
    Name = "jenkins-igw"
  })
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip_nat.id
  subnet_id = aws_subnet.public_subnet.id

  tags = merge(var.common_tags, {
    Name = "jenkins-nat-gw"
  })
}

resource "aws_eip" "eip_nat" {
  domain = "vpc"
  tags   = var.common_tags
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.jenkins_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = merge(var.common_tags, {
    Name = "jenkins-public-rt"
  })
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.jenkins_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = merge(var.common_tags, {
    Name = "jenkins-private-rt"
  })
}

resource "aws_route_table_association" "public_rt_association" {
  subnet_id = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_rt_association_2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_rt_association" {
  subnet_id = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
