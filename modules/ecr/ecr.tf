
variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

resource "aws_ecr_repository" "project_repo" {
  name = var.repository_name
}