data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_iam_policy_document" "kms" {
  statement {
    sid    = "Enable IAM User permissions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
    }
    actions = [
      "kms:*",
    ]
    resources = ["*"]
  }
  statement {
    sid    = "Enable logs to use this KMS"
    effect = "Allow"
    principals {
      type = "Service"
      identifiers = [
        "logs.${data.aws_region.current.name}.amazonaws.com",
      ]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
    condition {
      test = "ArnLike"
      values = [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*",
      ]
      variable = "kms:EncryptionContext:aws:logs:arn"
    }
  }
}

resource "aws_kms_key" "main" {
  count                   = var.enable_cw_logging ? 1 : 0
  description             = "KMS key for encrypting WAF logs in CloudWatch Log Group"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms.json
}

resource "aws_cloudwatch_log_group" "main" {
  count             = var.enable_cw_logging ? 1 : 0
  name              = "aws-waf-logs-${var.acl_name}-log-group"
  retention_in_days = var.retention_in_days
  kms_key_id        = var.kms_key_id != null ? var.kms_key_id : aws_kms_key.main[0].arn
}

resource "random_string" "main" {
  length           = 8
  special          = true
  upper            = false
  override_special = "-"
}

module "s3" {
  count = var.enable_s3_logging ? 1 : 0

  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket = lower("aws-waf-logs-${var.acl_name}-${random_string.main.id}")
  acl    = "log-delivery-write"

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  versioning = {
    enabled = false
  }

  force_destroy = true

  attach_deny_insecure_transport_policy = true
}

resource "aws_wafv2_web_acl_logging_configuration" "cw_log" {
  count = var.enable_cw_logging ? 1 : 0
  log_destination_configs = [
  var.log_group_name != null ? var.log_group_name : aws_cloudwatch_log_group.main[0].arn]
  resource_arn = aws_wafv2_web_acl.main.arn
}

resource "aws_wafv2_web_acl_logging_configuration" "s3_log" {
  count = var.enable_s3_logging ? 1 : 0
  log_destination_configs = [
    var.s3_bucket_name != null ? var.s3_bucket_name : module.s3[0].s3_bucket_arn,
  ]
  resource_arn = aws_wafv2_web_acl.main.arn
}
