# Main Terraform configuration file for AWS infrastructure

# Specify the required provider
provider "aws" {
  region = var.aws_region
}

# Define variables for customization
variable "aws_region" {
  description = "AWS region where resources will be created"
  default     = "us-east-1"
}

variable "project_type" {
  description = "Type of project: 'database' or 'storage'"
  default     = "database"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Main-VPC"
  }
}

# Create public and private subnets
resource "aws_subnet" "public" {
  # Two public subnets are created to ensure high availability by placing them in different availability zones.
  count                  = 2
  vpc_id                 = aws_vpc.main.id
  cidr_block             = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index)
  map_public_ip_on_launch = true
  availability_zone      = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "Public-Subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count                  = 2
  vpc_id                 = aws_vpc.main.id
  cidr_block             = cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + 2)
  availability_zone      = data.aws_availability_zones.available.names[count.index]
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
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "NAT-Gateway"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

# Security Groups
resource "aws_security_group" "eks" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "EKS-SG"
  }
}

# Create EKS cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "main-eks-cluster"
  cluster_version = "1.27"
  subnets         = aws_subnet.public[*].id
  vpc_id          = aws_vpc.main.id

  node_groups_defaults = {
    desired_capacity = 2
    min_size         = 1
    max_size         = 5
  }

  manage_aws_auth = true
}

# Create RDS instance if project type is 'database'
resource "aws_db_instance" "rds" {
  count                      = var.project_type == "database" ? 1 : 0
  allocated_storage          = 20
  engine                     = "postgres"
  engine_version             = "14"
  instance_class             = "db.t3.micro"
  name                       = "exampledb"
  username                   = "admin"
  password                   = "password"
  publicly_accessible        = false
  skip_final_snapshot        = true
  vpc_security_group_ids     = [aws_security_group.eks.id]
  db_subnet_group_name       = aws_db_subnet_group.main.id
}

resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id
  tags = {
    Name = "Main-DB-Subnet-Group"
  }
}

# Create S3 bucket if project type is 'storage'
resource "aws_s3_bucket" "storage" {
  count = var.project_type == "storage" ? 1 : 0
  bucket = "example-storage-bucket-${random_id.bucket_id.hex}"

  tags = {
    Name = "Example-Storage-Bucket"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 8
}
