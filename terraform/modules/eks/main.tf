# Módulo para la creación del clúster EKS

# Variables de entrada

# ID de la VPC donde se desplegará el clúster
variable "vpc_id" {
  description = "ID de la VPC donde se desplegará el clúster"
  type        = string
}

# Lista de subnets públicas para el clúster EKS
variable "public_subnets" {
  description = "Lista de subnets públicas donde se alojará el clúster EKS"
  type        = list(string)
}

# Crear el rol IAM para los nodos
resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "eks-node-role"
  }
}

# Adjuntar políticas necesarias al rol IAM
resource "aws_iam_role_policy_attachment" "eks_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSCNIPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_registry_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Crear el clúster EKS utilizando el módulo oficial de Terraform
module "eks" {
  source          = "terraform-aws-modules/eks/aws"

  # Nombre y versión del clúster
  cluster_name    = "main-eks-cluster"
  cluster_version = "1.27"

  # Redes
  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnets
}

# Configuración del grupo de nodos
resource "aws_eks_node_group" "default" {
  cluster_name    = module.eks.cluster_name
  node_group_name = "default"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.public_subnets

  scaling_config {
    desired_size = 2
    max_size     = 5
    min_size     = 1
  }

  instance_types = ["t3.medium"]
}

# Outputs del módulo

# Nombre del clúster creado
output "cluster_name" {
  description = "Nombre del clúster creado"
  value       = module.eks.cluster_id
}

# Endpoint del clúster
output "cluster_endpoint" {
  description = "Endpoint del clúster EKS para comunicación API"
  value       = module.eks.cluster_endpoint
}

# ARN del clúster creado
output "cluster_arn" {
  description = "ARN del clúster EKS creado"
  value       = module.eks.cluster_arn
}
