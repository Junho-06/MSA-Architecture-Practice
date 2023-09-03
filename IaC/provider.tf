terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.15.0"
    }
  }
  cloud {
    hostname     = "app.terraform.io"
    organization = "solo-study"
    workspaces {
      name = "msa-practice"
    }
  }
}

provider "aws" {
  region = var.region
}