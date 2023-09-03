resource "aws_vpc" "msa_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "msa_vpc"
  }
}