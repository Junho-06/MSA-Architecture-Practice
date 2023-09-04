resource "aws_ecr_repository" "msa_ecr_go" {
  name                 = "msa_ecr_go_registry"
  force_delete         = true

  tags = {
    Name = "msa_ecr_go_registry"
  }
}

resource "aws_ecr_repository" "msa_ecr_spring" {
  name                 = "msa_ecr_spring_registry"
  force_delete         = true

  tags = {
    Name = "msa_ecr_spring_registry"
  }
}