## This tf file will setup Datadog AWS integration

resource "datadog_integration_aws" "core" {
  count      = var.enable_datadog_aws_integration ? 1 : 0
  account_id = var.aws_account_id
  role_name  = "datadog-integration-role"

  host_tags = [
    "namespace:${var.namespace}",
    "env:${var.env}"
  ]

  account_specific_namespace_rules = var.account_specific_namespace_rules
  excluded_regions                 = var.excluded_regions
  filter_tags                      = var.filter_tags
}

resource "datadog_integration_aws_lambda_arn" "main_collector" {
  account_id = var.aws_account_id
  lambda_arn = aws_cloudformation_stack.datadog_forwarder.outputs.DatadogForwarderArn
}

resource "datadog_integration_aws_log_collection" "main" {
  account_id = var.aws_account_id
  services = [
    "s3",
    "elb",
    "elbv2",
    "cloudfront",
    "redshift",
    "lambda"
  ]
}

resource "aws_iam_role" "datadog_integration" {
  count = var.enable_datadog_aws_integration ? 1 : 0
  name  = "datadog-integration-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::464622532012:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "StringEquals": {
          "sts:ExternalId": "${datadog_integration_aws.core[0].external_id}"
        }
      }
    }
  ]
}
EOF

  tags = merge(local.default_tags, {
    description = "This role allows the datadog AWS account to access this account for metrics collection"
  })
}

resource "aws_iam_policy" "datadog_core" {
  count       = var.enable_datadog_aws_integration ? 1 : 0
  name        = "datadog-core-integration"
  path        = "/"
  description = "This IAM policy allows for core datadog integration permissions"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
               "apigateway:GET",
                "autoscaling:Describe*",
                "budgets:ViewBudget",
                "cloudfront:GetDistributionConfig",
                "cloudfront:ListDistributions",
                "cloudtrail:DescribeTrails",
                "cloudtrail:GetTrailStatus",
                "cloudtrail:LookupEvents",
                "cloudwatch:Describe*",
                "cloudwatch:Get*",
                "cloudwatch:List*",
                "codedeploy:List*",
                "codedeploy:BatchGet*",
                "directconnect:Describe*",
                "dynamodb:List*",
                "dynamodb:Describe*",
                "ec2:Describe*",
                "ecs:Describe*",
                "ecs:List*",
                "elasticache:Describe*",
                "elasticache:List*",
                "elasticfilesystem:DescribeFileSystems",
                "elasticfilesystem:DescribeTags",
                "elasticfilesystem:DescribeAccessPoints",
                "elasticloadbalancing:Describe*",
                "elasticmapreduce:List*",
                "elasticmapreduce:Describe*",
                "es:ListTags",
                "es:ListDomainNames",
                "es:DescribeElasticsearchDomains",
                "health:DescribeEvents",
                "health:DescribeEventDetails",
                "health:DescribeAffectedEntities",
                "kinesis:List*",
                "kinesis:Describe*",
                "lambda:AddPermission",
                "lambda:GetPolicy",
                "lambda:List*",
                "lambda:RemovePermission",
                "logs:DeleteSubscriptionFilter",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:DescribeSubscriptionFilters",
                "logs:FilterLogEvents",
                "logs:PutSubscriptionFilter",
                "logs:TestMetricFilter",
                "rds:Describe*",
                "rds:List*",
                "redshift:DescribeClusters",
                "redshift:DescribeLoggingStatus",
                "route53:List*",
                "s3:GetBucketLogging",
                "s3:GetBucketLocation",
                "s3:GetBucketNotification",
                "s3:GetBucketTagging",
                "s3:ListAllMyBuckets",
                "s3:PutBucketNotification",
                "ses:Get*",
                "sns:List*",
                "sns:Publish",
                "sqs:ListQueues",
                "states:ListStateMachines",
                "states:DescribeStateMachine",
                "support:*",
                "tag:GetResources",
                "tag:GetTagKeys",
                "tag:GetTagValues",
                "xray:BatchGetTraces",
                "xray:GetTraceSummaries"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "datadog_core_attach" {
  count      = var.enable_datadog_aws_integration ? 1 : 0
  role       = aws_iam_role.datadog_integration[0].name
  policy_arn = aws_iam_policy.datadog_core[0].arn
}
