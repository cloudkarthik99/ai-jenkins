data "aws_vpc" "existing_vpc" {
  id = var.vpc_id
}

data "aws_subnet" "private_subnet" {
  id = var.private_subnet_id
}

data "aws_subnet" "public_subnet" {
  id = var.public_subnet_id
}

data "aws_subnet" "public_subnet2" {
  id = var.public_subnet2_id
}

data "aws_vpc_endpoint" "ec2_vpc_endpoint" {
  vpc_id = data.aws_vpc.existing_vpc.id
  service_name = "com.amazonaws.eu-central-1.ec2"
}
