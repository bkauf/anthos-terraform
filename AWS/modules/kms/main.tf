terraform {
  required_version = ">= 0.12.23"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70.0"
    }
  }
}

data "aws_caller_identity" "current" {}

resource "aws_kms_key" "database_encryption_kms_key" {
  description = "${var.anthos_prefix} AWS Database Encryption KMS Key"
 
}

resource "aws_kms_alias" "database_encryption_kms_key_alias" {
  target_key_id = aws_kms_key.database_encryption_kms_key.arn
  name          = "alias/${var.anthos_prefix}-database-encryption-key"
}
