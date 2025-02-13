variable "common_tags" {
  type = map(string)
  default = {
    Origin      = "Terraform"
    Project     = "AI"
    Application = "Jenkins"
  }
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the existing private subnet"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the existing public subnet"
  type        = string
}

variable "public_subnet2_id" {
  description = "ID of the existing public subnet"
  type        = string
}