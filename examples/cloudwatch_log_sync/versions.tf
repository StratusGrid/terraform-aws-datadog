terraform {
  required_version = ">= 1.1"

  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = ">= 3.18"
    }
    aws = {
      version = ">= 3.63"
      source  = "hashicorp/aws"
      version = ">= 4.9"
    }
  }
}
