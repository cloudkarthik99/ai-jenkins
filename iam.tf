resource "aws_iam_role" "jenkins_master_role" {
  name = "jenkins-master-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = var.common_tags
}


# resource "aws_iam_role_policy_attachment" "jenkins_master_role_policy_attachment" {
#   role = aws_iam_role.jenkins_master_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
# }
resource "aws_iam_role_policy" "jenkins_master_policy" {
  name = "jenkins-master-policy"
  role = aws_iam_role.jenkins_master_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:*",
          "elasticloadbalancing:*",
          "ssm:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "jenkins_master_profile" {
  name = "jenkins-master-profile"
  role = aws_iam_role.jenkins_master_role.name
}