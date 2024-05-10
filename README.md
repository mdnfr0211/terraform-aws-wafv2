# terraform-aws-wafv2
Terraform Module to create AWS WAF V2

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_wafv2_web_acl.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl_name"></a> [acl\_name](#input\_acl\_name) | The name assigned to the Web ACL. | `string` | `null` | no |
| <a name="input_and_not_statement_rules"></a> [and\_not\_statement\_rules](#input\_and\_not\_statement\_rules) | List of WAF rule statements that are combined with a logical AND and NOT. | `any` | `[]` | no |
| <a name="input_and_statement_rules"></a> [and\_statement\_rules](#input\_and\_statement\_rules) | List of WAF rule statements that are combined with a logical AND. | `any` | `[]` | no |
| <a name="input_aws_managed_rules"></a> [aws\_managed\_rules](#input\_aws\_managed\_rules) | List of AWS Managed Rules to associate with the Web ACL. | `any` | `[]` | no |
| <a name="input_default_action"></a> [default\_action](#input\_default\_action) | The action to take for requests that don't match any rules in the Web ACL. Allowed values are 'allow', 'block', 'count'. | `string` | `"allow"` | no |
| <a name="input_description"></a> [description](#input\_description) | A brief description or note for the Web ACL. | `string` | `null` | no |
| <a name="input_geo_match_rules"></a> [geo\_match\_rules](#input\_geo\_match\_rules) | List of Geo match rules to associate with the Web ACL. | `any` | `[]` | no |
| <a name="input_http_method_rules"></a> [http\_method\_rules](#input\_http\_method\_rules) | List of HTTP method match rules to associate with the Web ACL. | `any` | `[]` | no |
| <a name="input_ip_set_match_rules"></a> [ip\_set\_match\_rules](#input\_ip\_set\_match\_rules) | List of IP set match rules to associate with the Web ACL. | `any` | `[]` | no |
| <a name="input_not_statement_rules"></a> [not\_statement\_rules](#input\_not\_statement\_rules) | List of WAF rule statements that are combined with a logical NOT. | `any` | `[]` | no |
| <a name="input_or_not_statement_rules"></a> [or\_not\_statement\_rules](#input\_or\_not\_statement\_rules) | List of WAF rule statements that are combined with a logical OR and NOT. | `any` | `[]` | no |
| <a name="input_or_statement_rules"></a> [or\_statement\_rules](#input\_or\_statement\_rules) | List of WAF rule statements that are combined with a logical OR. | `any` | `[]` | no |
| <a name="input_override_action"></a> [override\_action](#input\_override\_action) | The action to override the default action for the rules in an associated rule group. Allowed values are 'none', 'count', 'block'. | `string` | `"none"` | no |
| <a name="input_rate_limit_rules"></a> [rate\_limit\_rules](#input\_rate\_limit\_rules) | List of Rate Limit rules to associate with the Web ACL. | `any` | `[]` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | Indicates whether the Web ACL is intended for an AWS CloudFront distribution or a regional application. Allowed values are 'CLOUDFRONT' or 'REGIONAL'. If 'CLOUDFRONT' is chosen, the provider must be set to 'US\_EAST\_1' (N. Virginia). | `string` | `"REGIONAL"` | no |
| <a name="input_single_header_rules"></a> [single\_header\_rules](#input\_single\_header\_rules) | List of single header match rules to associate with the Web ACL. | `any` | `[]` | no |
| <a name="input_uri_path_rules"></a> [uri\_path\_rules](#input\_uri\_path\_rules) | List of URI path match rules to associate with the Web ACL. | `any` | `[]` | no |
| <a name="input_visibility_config"></a> [visibility\_config](#input\_visibility\_config) | Configuration settings for enabling Amazon CloudWatch metrics and web request sample collection. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the WAFv2 WebACL. |
| <a name="output_capacity"></a> [capacity](#output\_capacity) | The web ACL capacity units (WCUs) currently being used by this web ACL. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the WAFv2 WebACL. |
| <a name="output_name"></a> [name](#output\_name) | The name of the WAFv2 WebACL. |