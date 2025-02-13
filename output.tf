output "alb_dns_name" {
  value = aws_lb.jenkins.dns_name
}

output "master_private_ip" {
  value = aws_instance.jenkins_master.private_ip
}

output "slave_private_ip" {
  value = aws_instance.jenkins_slave.private_ip
}