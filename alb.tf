resource "aws_lb" "jenkins" {
  name               = "jenkins-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets           = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_2.id]
  enable_cross_zone_load_balancing = true

  tags = merge(var.common_tags, {
    Name = "jenkins-alb"
  })
}

resource "aws_lb_target_group" "jenkins_alb_target_group" {
  name = "jenkins-target-group"
  port = 8080
  protocol = "HTTP"
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = var.common_tags
}

resource "aws_lb_listener" "jenkins_http_listener" {
  load_balancer_arn = aws_lb.jenkins.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_alb_target_group.arn
  }
}