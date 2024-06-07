variable "acl_name" {
  description = "The name assigned to the Web ACL."
  type        = string
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
  type        = any
  default     = []
}

variable "ip_set_match_rules" {
  description = "List of IP set match rules to associate with the Web ACL."
  type        = any
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
  type        = any
  default     = []
}

variable "rate_limit_rules" {
  description = "List of Rate Limit rules to associate with the Web ACL."
  type        = any
  default     = []
}

variable "and_statement_rules" {
  description = "List of WAF rule statements that are combined with a logical AND."
  type        = any
  default     = []
}

variable "or_statement_rules" {
  description = "List of WAF rule statements that are combined with a logical OR."
  type        = any
  default     = []
}

variable "not_statement_rules" {
  description = "List of WAF rule statements that are combined with a logical NOT."
  type        = any
  default     = []
}

variable "and_not_statement_rules" {
  description = "List of WAF rule statements that are combined with a logical AND and NOT."
  type        = any
  default     = []
}

variable "or_not_statement_rules" {
  description = "List of WAF rule statements that are combined with a logical OR and NOT."
  type        = any
  default     = []
}

variable "enable_cw_logging" {
  description = "Determines whether CloudWatch logging should be enabled for the WAF web ACL."
  type        = bool
  default     = false
}

variable "retention_in_days" {
  description = "The number of days to retain the logs in the CloudWatch Log Group."
  type        = number
  default     = 365
}

variable "kms_key_id" {
  description = "The ID of an existing KMS key to be used for encrypting the CloudWatch Log Group. If not provided, a new KMS key will be created."
  type        = string
  default     = null
}

variable "enable_s3_logging" {
  description = "Determines whether S3 logging should be enabled for the WAF web ACL."
  type        = bool
  default     = false
}

variable "log_group_name" {
  description = "The name of an existing CloudWatch Log Group to be used for logging. If not provided, a new CloudWatch Log Group will be created."
  type        = string
  default     = null
}

variable "s3_bucket_name" {
  description = "The name of an existing S3 bucket to be used for logging. If not provided, a new S3 bucket will be created."
  type        = string
  default     = null
}

variable "create_alb_association" {
  description = "Determines whether to create an association between the WAF web ACL and Application Load Balancers (ALBs)."
  type        = bool
  default     = false
}

variable "alb_arn_list" {
  description = "A list of ARNs of the Application Load Balancers (ALBs) to associate with the WAF web ACL."
  type        = list(string)
  default     = []
}

variable "create_apigw_association" {
  description = "Determines whether to create an association between the WAF web ACL and API Gateways."
  type        = bool
  default     = false
}

variable "apigw_arn_list" {
  description = "A list of ARNs of the API Gateways to associate with the WAF web ACL."
  type        = list(string)
  default     = []
}
