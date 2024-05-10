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
