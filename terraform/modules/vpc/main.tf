# Módulo para la creación de la VPC

# Variables de entrada
variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC"
  type        = string
}

variable "region" {
  description = "Región donde se desplegarán los recursos"
  type        = string
}

# Crear la VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Main-VPC"
  }
}

# Subnets públicas
resource "aws_subnet" "public" {
  count                  = 2
  vpc_id                 = aws_vpc.main.id
  cidr_block             = cidrsubnet(var.vpc_cidr, 4, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-${count.index}"
  }
}

# Subnets privadas
resource "aws_subnet" "private" {
  count      = 2
  vpc_id     = aws_vpc.main.id
  cidr_block = cidrsubnet(var.vpc_cidr, 4, count.index + 2)

  tags = {
    Name = "Private-Subnet-${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Internet-Gateway"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "NAT-Gateway"
  }
}

# Elastic IP para NAT Gateway
resource "aws_eip" "nat" {
  # Elimina el argumento `vpc = true`, ya que es innecesario
  tags = {
    Name = "NAT-EIP"
  }
}

# Outputs del módulo
output "vpc_id" {
  description = "ID de la VPC creada"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "Lista de subnets públicas"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "Lista de subnets privadas"
  value       = aws_subnet.private[*].id
}
