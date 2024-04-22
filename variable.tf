variable "acl_name" {
  description = "The name assigned to the Web ACL."
  type        = string
  default     = null
}

variable "description" {
  description = "A brief description or note for the Web ACL."
  type        = string
  default     = null
}

variable "scope" {
  description = "Indicates whether the Web ACL is intended for an AWS CloudFront distribution or a regional application. Allowed values are 'CLOUDFRONT' or 'REGIONAL'. If 'CLOUDFRONT' is chosen, the provider must be set to 'US_EAST_1' (N. Virginia)."
  type        = string
  default     = "REGIONAL"
}

variable "default_action" {
  description = "The action to take for requests that don't match any rules in the Web ACL. Allowed values are 'allow', 'block', 'count'."
  type        = string
  default     = "allow"
}

variable "visibility_config" {
  description = "Configuration settings for enabling Amazon CloudWatch metrics and web request sample collection."
  type        = map(string)
  default     = {}
}

variable "override_action" {
  description = "The action to override the default action for the rules in an associated rule group. Allowed values are 'none', 'count', 'block'."
  type        = string
  default     = "none"
}

variable "aws_managed_rules" {
  description = "List of AWS Managed Rules to associate with the Web ACL."
  type        = list(any)
  default     = []
}

variable "ip_set_match_rules" {
  description = "List of IP set match rules to associate with the Web ACL."
  type        = list(any)
  default     = []
}

variable "single_header_rules" {
  description = "List of single header match rules to associate with the Web ACL."
  type        = any
  default     = []
}

variable "http_method_rules" {
  description = "List of HTTP method match rules to associate with the Web ACL."
  type        = any
  default     = []
}

variable "uri_path_rules" {
  description = "List of URI path match rules to associate with the Web ACL."
  type        = any
  default     = []
}

variable "geo_match_rules" {
  description = "List of Geo match rules to associate with the Web ACL."
  type        = list(any)
  default     = []
}

variable "rate_limit_rules" {
  description = "List of Rate Limit rules to associate with the Web ACL."
  type        = list(any)
  default     = []
}

variable "and_statement_rules" {
  description = "List of WAF rule statements that are combined with a logical AND."
  type        = list(any)
  default     = []
}

variable "or_statement_rules" {
  description = "List of WAF rule statements that are combined with a logical OR."
  type        = list(any)
  default     = []
}

variable "not_statement_rules" {
  description = "List of WAF rule statements that are combined with a logical NOT."
  type        = list(any)
  default     = []
}

variable "and_not_statement_rules" {
  description = "List of WAF rule statements that are combined with a logical AND and NOT."
  type = list(any)
  default = []
}

variable "or_not_statement_rules" {
  description = "List of WAF rule statements that are combined with a logical OR and NOT."
  type = list(any)
  default = []
}
