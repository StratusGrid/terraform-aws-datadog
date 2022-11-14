variable "dd_api_key" {
  type        = string
  default     = "1234567890"
  description = "DataDog API key"
}

variable "dd_app_key" {
  type        = string
  default     = "1234567890"
  description = "DataDog APP key"
}

variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "AWS Region"
}

provider "datadog" {
  api_key = var.dd_api_key
  app_key = var.dd_app_key
}

provider "aws" {
  region = var.aws_region
}

module "datadog" {
  source                         = "scribd/datadog/aws"
  version                        = "~>1"
  datadog_api_key                = var.dd_api_key
  aws_region                     = var.aws_region
  create_elb_logs_bucket         = false
  enable_datadog_aws_integration = false
  cloudwatch_log_groups          = ["cloudwatch_log_group_1", "cloudwatch_log_group_2"]
}
