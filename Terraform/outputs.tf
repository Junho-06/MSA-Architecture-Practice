output "go_ecr_repository_url" {
  value = aws_ecr_repository.msa_ecr_go.repository_url
}

output "spring_ecr_repository_url" {
  value = aws_ecr_repository.msa_ecr_spring.repository_url
}

output "vpc_id" {
  value = aws_vpc.msa_vpc.id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}