resource "aws_ecr_repository" "ecr_repo" {
  name = "ecr_repo_${var.env}"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}