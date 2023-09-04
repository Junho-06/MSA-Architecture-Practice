output "go_ecr_repository_url" {
  value = aws_ecr_repository.msa_ecr_go.repository_url
}

output "spring_ecr_repository_url" {
  value = aws_ecr_repository.msa_ecr_spring.repository_url
}