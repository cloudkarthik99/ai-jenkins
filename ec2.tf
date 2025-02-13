data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "jenkins_master" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.medium"
  subnet_id     = data.aws_subnet.private_subnet.id
  key_name      = "jenkins-master"

  vpc_security_group_ids = [aws_security_group.jenkins_master.id]
  iam_instance_profile   = aws_iam_instance_profile.jenkins_master_profile.name

  user_data = base64encode(file("${path.module}/user-data/master.sh"))

  tags = merge(var.common_tags, {
    Name = "jenkins-master"
  })
}

resource "aws_instance" "jenkins_slave" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.medium"
  subnet_id     = data.aws_subnet.private_subnet.id
  key_name      = "jenkins-slave"

  vpc_security_group_ids = [aws_security_group.jenkins_slave.id]

  user_data = base64encode(file("${path.module}/user-data/slave.sh"))

  tags = merge(var.common_tags, {
    Name = "jenkins-slave"
  })
}