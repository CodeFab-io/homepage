terraform {
  required_version = "~> 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.53"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = var.region
}

provider "aws" {
  # Cloudfront needs the certificates to exist in us-east-1 (North Virginia)
  alias  = "acm_provider"
  region = "us-east-1"
}
