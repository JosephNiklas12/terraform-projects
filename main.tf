terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
    
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "learn" {
  bucket = "terraform-learn-${random_id.suffix.hex}"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket_public_access_block" "learn" {
  bucket = aws_s3_bucket.learn.id

  block_public_acls      = true
  block_public_policy    = true
  ignore_public_acls     = true
  restrict_public_buckets = true
}

resource = "aws_s3_bucket" "learn" {
  bucket = "terraform-learn-${random_id.suffix.hex}"

  tags ={
    Name              = "terraform-learn-bucket" 
    Environnment      = "learning"
    ManagedBy         = "terraform"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "learn" {
  bucket = aws_s3_bucket.learn.id

  rule{
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" 
    }
  }
}
