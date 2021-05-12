resource "aws_cloudformation_stack" "datadog-forwarder" {
  name         = "${var.aws_region}-${local.stack_prefix}datadog-forwarder"
  capabilities = ["CAPABILITY_IAM", "CAPABILITY_NAMED_IAM", "CAPABILITY_AUTO_EXPAND"]
  parameters = {
    DdApiKeySecretArn = data.aws_secretsmanager_secret.dd_api_key.id
    DdApiKey          = "dummy-value"
    DdTags            = replace(jsonencode(var.aws_integration_tags), "/[{}\"]/", "")
    DdSite            = var.dd_forwarder_dd_site
    ExcludeAtMatch    = var.log_exclude_at_match
    FunctionName      = "${var.aws_region}-${local.stack_prefix}datadog-forwarder"
    ReservedConcurrency = var.reserved_concurrency
  }
  template_url = "https://datadog-cloudformation-template.s3.amazonaws.com/aws/forwarder/${var.dd_forwarder_template_version}.yaml"

  lifecycle {
    ignore_changes = [
      parameters["DdApiKey"]
    ]
  }
}

data "aws_secretsmanager_secret" "dd_api_key" {
  name = var.datadog_api_key_name
}
data "aws_secretsmanager_secret_version" "dd_api_key" {
  secret_id = data.aws_secretsmanager_secret.dd_api_key.id
}
