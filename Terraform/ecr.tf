locals {
  ecr_names = {
    msa_ecr_go_registry = "msa_ecr_go_registry",
    msa_ecr_spring_registry = "msa_ecr_spring_registry"
  }
  region = "ap-northeast-2"
}

module "ecr" {
  source = "./modules/ecr"

  for_each = local.ecr_names
  name     = each.value
}

output "ecr_url" {
  value = [
    for v in module.ecr : v.ecr_repository_url
  ]
}