# Archivo principal de Terraform para configurar los módulos

# Proveedor de AWS
provider "aws" {
  region = var.aws_region
}

# Variables principales
variable "aws_region" {
  description = "Región de AWS donde se crearán los recursos"
  default     = "us-east-1"
}

variable "project_type" {
  description = "Tipo de proyecto: 'database' para RDS o 'storage' para S3"
  default     = "database"
}

# Llamar al módulo de VPC
module "vpc" {
  source  = "./modules/vpc"
  vpc_cidr = "10.0.0.0/16"
  region   = var.aws_region
}

# Llamar al módulo de EKS
module "eks" {
  source          = "./modules/eks"
  vpc_id          = module.vpc.vpc_id
  public_subnets        = module.vpc.public_subnets
}

# Llamar al módulo de RDS (si project_type es 'database')
module "rds" {
  source           = "./modules/rds"
  enabled          = var.project_type == "database"
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnets
  db_instance_class = "db.t3.micro"
  db_name          = "exampledb"
  db_username      = "admin"
  db_password      = "password"
}

# Llamar al módulo de S3 (si project_type es 'storage')
module "s3" {
  source  = "./modules/s3"
  enabled = var.project_type == "storage"
}

# Outputs globales para usar en otros contextos
output "vpc_id" {
  description = "ID de la VPC creada"
  value       = module.vpc.vpc_id
}

output "eks_cluster_name" {
  description = "Nombre del clúster EKS creado"
  value       = module.eks.cluster_name
}

output "rds_endpoint" {
  description = "Endpoint de la base de datos RDS"
  value       = module.rds.db_endpoint
}

output "s3_bucket_name" {
  description = "Nombre del bucket S3 creado"
  value       = module.s3.bucket_name
}
