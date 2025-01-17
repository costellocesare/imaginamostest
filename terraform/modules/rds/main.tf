# Módulo para la creación de RDS

# Variables de entrada

# Variable para habilitar o deshabilitar RDS
variable "enabled" {
  description = "Habilita o deshabilita la creación de RDS"
  type        = bool
}

# ID de la VPC
variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

# Lista de subnets privadas para RDS
variable "private_subnets" {
  description = "Subnets privadas donde se desplegará la base de datos"
  type        = list(string)
}

# Clase de la instancia RDS
variable "db_instance_class" {
  description = "Clase de instancia para la base de datos"
  type        = string
}

# Nombre de la base de datos
variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
}

# Nombre de usuario para la base de datos
variable "db_username" {
  description = "Usuario administrador para la base de datos"
  type        = string
}

# Contraseña de la base de datos
variable "db_password" {
  description = "Contraseña para la base de datos"
  type        = string
  sensitive   = true
}

# Recurso principal para crear la base de datos RDS
resource "aws_db_instance" "main" {
  count                     = var.enabled ? 1 : 0
  allocated_storage         = 20
  engine                    = "postgres"
  engine_version            = "14"
  instance_class            = var.db_instance_class
  name                      = var.db_name
  username                  = var.db_username
  password                  = var.db_password
  publicly_accessible       = false
  vpc_security_group_ids    = [] # Puedes agregar security groups específicos
  db_subnet_group_name      = aws_db_subnet_group.main.id
  skip_final_snapshot       = true
}

# Subnet Group para la base de datos
resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "RDS-Subnet-Group"
  }
}

# Outputs del módulo

# Endpoint de la base de datos
output "db_endpoint" {
  description = "Endpoint de conexión para la base de datos"
  value       = aws_db_instance.main[0].endpoint
  condition   = var.enabled
}

# Nombre de la base de datos
output "db_name" {
  description = "Nombre de la base de datos creada"
  value       = aws_db_instance.main[0].name
  condition   = var.enabled
}
