variable "acl_name" {
  description = "The name of the Web ACL."
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the Web ACL."
  type        = string
  default     = null
}

variable "scope" {
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application. Valid values are CLOUDFRONT or REGIONAL. To work with CloudFront, you must also specify the region US_EAST_1 (N. Virginia) on the provider."
  type        = string
  default     = "REGIONAL"
}

variable "default_action" {
  description = "The action to perform if none of the rules contained in the web ACL match."
  type        = string
  default     = "allow"
}

variable "visibility_config" {
  description = "Defines and enables Amazon CloudWatch metrics and web request sample collection."
  type        = map(string)
  default     = {}
}

variable "override_action" {
  description = "The override action to apply to the rules in a rule group."
  type        = string
  default     = "none"
}

variable "aws_managed_rules" {
  description = "The AWS Managed Rules to associate with the web ACL."
  type        = list(any)
  default     = []
}

variable "ip_set_match_rules" {
  description = "The IP set match rules to associate with the web ACL."
  type        = list(any)
  default     = []
}

variable "single_header_rules" {
  description = "The single header rules to associate with the web ACL."
  type        = list(any)
  default     = []
}

variable "http_method_rules" {
  description = "The HTTP method rules to associate with the web ACL."
  type        = list(any)
  default     = []
}

variable "uri_path_rules" {
  description = "The URI path rules to associate with the web ACL."
  type        = list(any)
  default     = []
}

variable "geo_match_rules" {
  description = "The Geo match rules to associate with the web ACL."
  type        = list(any)
  default     = []
}

variable "rate_limit_rules" {
  description = "The Rate Limit rules to associate with the web ACL."
  type        = list(any)
  default     = []
}
