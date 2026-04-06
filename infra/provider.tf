terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"   # ✅ use latest stable
    }
  }
  required_version = ">= 1.3.0"
}
