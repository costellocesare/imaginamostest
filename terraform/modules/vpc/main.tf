# Módulo para la creación de la VPC

# Variable para el bloque CIDR de la VPC
variable "vpc_cidr" {
  description = "Bloque CIDR para la VPC"
}

# Variable para la región de despliegue
variable "region" {
  description = "Región de despliegue"
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

# Crear subnets públicas
resource "aws_subnet" "public" {
  count                  = 2
  vpc_id                 = aws_vpc.main.id
  cidr_block             = cidrsubnet(var.vpc_cidr, 4, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "Public-Subnet-${count.index}"
  }
}

# Crear subnets privadas
resource "aws_subnet" "private" {
  count                  = 2
  vpc_id                 = aws_vpc.main.id
  cidr_block             = cidrsubnet(var.vpc_cidr, 4, count.index + 2)

  tags = {
    Name = "Private-Subnet-${count.index}"
  }
}

# Exportar los recursos
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}