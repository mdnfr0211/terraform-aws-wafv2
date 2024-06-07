output "name" {
  description = "The name of the WAFv2 WebACL."
  value       = aws_wafv2_web_acl.main.name
}

output "arn" {
  description = "The ARN of the WAFv2 WebACL."
  value       = aws_wafv2_web_acl.main.arn
}

output "id" {
  description = "The ID of the WAFv2 WebACL."
  value       = aws_wafv2_web_acl.main.id
}

output "capacity" {
  description = "The web ACL capacity units (WCUs) currently being used by this web ACL."
  value       = aws_wafv2_web_acl.main.capacity
}

output "log_group_id" {
  description = "ID of the Log Group Associated with WAF Logging"
  value       = try(aws_cloudwatch_log_group.main[0].id, null)
}

output "log_group_name" {
  description = "Name of the Log Group Associated with WAF Logging"
  value       = try(aws_cloudwatch_log_group.main[0].name, null)
}

output "log_group_arn" {
  description = "ARN of the Log Group Associated with WAF Logging"
  value       = try(aws_cloudwatch_log_group.main[0].arn, null)
}

output "s3_bucket_name" {
  description = "Name/ID of the S3 Bucket Associated with WAF Logging"
  value       = try(module.s3[0].s3_bucket_id, null)
}

output "s3_bucket_arn" {
  description = "ARN of the S3 Bucket Associated with WAF Logging"
  value       = try(module.s3[0].s3_bucket_arn, null)
}
