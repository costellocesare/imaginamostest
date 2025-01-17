# Módulo para la creación del clúster EKS

# Variables de entrada

# ID de la VPC donde se desplegará el clúster
variable "vpc_id" {
  description = "ID de la VPC donde se desplegará el clúster"
  type        = string
}

# Lista de subnets públicas para el clúster EKS
variable "subnets" {
  description = "Subnets públicas donde se alojará el clúster EKS"
  type        = list(string)
}

# Crear el clúster EKS utilizando el módulo oficial de Terraform
module "eks" {
  source          = "terraform-aws-modules/eks/aws"

  cluster_name    = "main-eks-cluster"
  cluster_version = "1.27" # Versión de Kubernetes a desplegar

  # Redes
  vpc_id  = var.vpc_id
  subnets = var.subnets

  # Configuración de los nodos del clúster
  node_groups_defaults = {
    desired_capacity = 2 # Número de nodos iniciales
    min_size         = 1 # Tamaño mínimo del grupo de nodos
    max_size         = 5 # Tamaño máximo del grupo de nodos
  }

  # Habilitar gestión de autorizaciones de AWS
  manage_aws_auth = true
}

# Exportar el nombre del clúster
output "cluster_name" {
  description = "Nombre del clúster creado"
  value       = module.eks.cluster_id
}

# Exportar el endpoint del clúster
output "cluster_endpoint" {
  description = "Endpoint del clúster EKS para comunicación API"
  value       = module.eks.cluster_endpoint
}

# Exportar el ARN del clúster
output "cluster_arn" {
  description = "ARN del clúster EKS creado"
  value       = module.eks.cluster_arn
}
