resource "aws_vpc" "msa_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "msa_vpc"
  }
}


resource "aws_subnet" "msa_public_subnet" {
  vpc_id     = aws_vpc.msa_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "msa_public_subnet"
  }
}
resource "aws_subnet" "msa_private_subnet_a" {
  vpc_id     = aws_vpc.msa_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-2a"

  tags = {
    Name = "msa_private_subnet_a"
  }
}
resource "aws_subnet" "msa_private_subnet_b" {
  vpc_id     = aws_vpc.msa_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-2b"

  tags = {
    Name = "msa_private_subnet_b"
  }
}


resource "aws_internet_gateway" "msa_igw" {
  vpc_id = aws_vpc.msa_vpc.id

  tags = {
    Name = "msa_igw"
  }
}
resource "aws_internet_gateway_attachment" "msa_igw_attachment" {
  internet_gateway_id = aws_internet_gateway.msa_igw.id
  vpc_id              = aws_vpc.msa_vpc.id
}


resource "aws_eip" "msa_nat_eip" {
  vpc = true

  tags = {
    Name = "msa_nat_eip"
  }
}
resource "aws_nat_gateway" "msa_nat" {
  allocation_id = aws_eip.msa_nat_eip.id
  subnet_id = aws_subnet.msa_public_subnet.id

  tags = {
    Name = "msa_nat"
    }
}


resource "aws_route_table" "msa_public_rtb" {
  vpc_id = aws_vpc.msa_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.msa_igw.id
  }

  tags = {
    Name = "msa_public_rtb"
  }
}
resource "aws_route_table" "msa_private_rtb_a" {
  vpc_id = aws_vpc.msa_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.msa_nat.id
  }

  tags = {
    Name = "msa_private_rtb_a"
  }
}
resource "aws_route_table" "msa_private_rtb_b" {
  vpc_id = aws_vpc.msa_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.msa_nat.id
  }

  tags = {
    Name = "msa_private_rtb_b"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.msa_public_subnet.id
  route_table_id = aws_route_table.msa_public_rtb.id
}
resource "aws_route_table_association" "private_subnet_a_association" {
  subnet_id      = aws_subnet.msa_private_subnet_a.id
  route_table_id = aws_route_table.msa_private_rtb_a.id
}
resource "aws_route_table_association" "private_subnet_b_association" {
  subnet_id      = aws_subnet.msa_private_subnet_b
  route_table_id = aws_route_table.msa_private_rtb_b.id
}