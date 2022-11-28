locals {
  stack_prefix = var.account_name == "" ? "" : "${var.account_name}-"
  default_tags = {
    account_name       = var.account_name
    terraform = "true"
  }
}
