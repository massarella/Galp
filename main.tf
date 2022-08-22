# Criação da VPC
resource "aws_vpc" "galp_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "galp_vpc"
  }
}

# Criação da Subnet Pública
resource "aws_subnet" "galp_public_subnet" {
  vpc_id     = aws_vpc.galp_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "galp_public_subnet"
  }
}

# Criação do Internet Gateway
resource "aws_internet_gateway" "galp_igw" {
  vpc_id = aws_vpc.galp_vpc.id

  tags = {
    Name = "galp_igw"
  }
}

# Criação da Tabela de Roteamento
resource "aws_route_table" "galp_rt" {
  vpc_id = aws_vpc.galp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.galp_igw.id
  }

  tags = {
    Name = "galp_rt"
  }
}

# Criação da Rota Default para Acesso à Internet
resource "aws_route" "galp_routetointernet" {
  route_table_id            = aws_route_table.galp_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.galp_igw.id
}

# Associação da Subnet Pública com a Tabela de Roteamento
resource "aws_route_table_association" "galp_pub_association" {
  subnet_id      = aws_subnet.galp_public_subnet.id
  route_table_id = aws_route_table.galp_rt.id
}