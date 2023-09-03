resource "aws_ecr_repository" "msa_ecr" {
  name                 = "msa_ecr_registry"

  tags = {
    Name = "msa_ecr_registry"
  }
}