output "datadog_logs_monitoring_lambda_function_name" {
  value       = aws_cloudformation_stack.datadog_forwarder.outputs.DatadogForwarderArn
  description = "Name of the lambda function for datadog logs monitoring"
}
output "datadog_iam_role" {
  value       = var.enable_datadog_aws_integration ? aws_iam_role.datadog_integration[0].name : ""
  description = "IAM role name for datadog"
}
