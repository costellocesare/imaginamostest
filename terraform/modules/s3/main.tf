# Módulo para la creación de S3

# Variable para habilitar o deshabilitar S3
variable "enabled" {
  description = "Habilita o deshabilita la creación del bucket S3"
  type        = bool
}

# Crear el bucket S3
resource "aws_s3_bucket" "storage" {
  count  = var.enabled ? 1 : 0
  bucket = "example-storage-bucket-${random_id.bucket_id.hex}"

  tags = {
    Name = "Example-Storage-Bucket"
  }
}

# Generar un ID aleatorio para el nombre del bucket
resource "random_id" "bucket_id" {
  byte_length = 8
}

# Outputs del módulo

# Nombre del bucket creado
output "bucket_name" {
  description = "Nombre del bucket creado"
  value       = length(aws_s3_bucket.storage) > 0 ? aws_s3_bucket.storage[0].bucket : null
}

# ARN del bucket creado
output "bucket_arn" {
  description = "ARN del bucket creado"
  value       = length(aws_s3_bucket.storage) > 0 ? aws_s3_bucket.storage[0].arn : null
}
