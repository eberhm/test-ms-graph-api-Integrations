resource "aws_ecr_repository" "migrator" {
  name                 = "${var.name}-${var.environment}-dbmigrator"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_ecr_lifecycle_policy" "dbMigrator" {
  repository = aws_ecr_repository.migrator.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })
}


output "aws_ecr_dbMigrator_repository_url" {
  value = aws_ecr_repository.migrator.repository_url
}
