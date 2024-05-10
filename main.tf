resource "aws_wafv2_web_acl" "main" {
  name        = var.acl_name
  description = var.description
  scope       = var.scope

  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }

    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = lookup(var.visibility_config, "cloudwatch_metrics_enabled", true)
    metric_name                = lookup(var.visibility_config, "metric_name", "${var.acl_name}-metric")
    sampled_requests_enabled   = lookup(var.visibility_config, "sampled_requests_enabled", true)
  }

  dynamic "rule" {
    for_each = var.aws_managed_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      override_action {
        dynamic "none" {
          for_each = var.override_action == "none" ? [1] : []
          content {}
        }
        dynamic "count" {
          for_each = var.override_action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = "AWS"

          dynamic "rule_action_override" {
            for_each = rule.value.rule_action_override
            content {
              name = rule_action_override.value["name"]
              action_to_use {
                dynamic "allow" {
                  for_each = rule_action_override.value["action_to_use"] == "allow" ? [1] : []
                  content {}
                }
                dynamic "block" {
                  for_each = rule_action_override.value["action_to_use"] == "block" ? [1] : []
                  content {}
                }
                dynamic "count" {
                  for_each = rule_action_override.value["action_to_use"] == "count" ? [1] : []
                  content {}
                }
                dynamic "challenge" {
                  for_each = rule_action_override.value["action_to_use"] == "challenge" ? [1] : []
                  content {}
                }
                dynamic "captcha" {
                  for_each = rule_action_override.value["action_to_use"] == "captcha" ? [1] : []
                  content {}
                }
              }
            }
          }
        }
      }

      dynamic "visibility_config" {
        for_each = length(lookup(rule.value, "visibility_config", {})) > 0 ? [rule.value.visibility_config] : []
        content {
          cloudwatch_metrics_enabled = lookup(visibility_config.value, "cloudwatch_metrics_enabled", true)
          metric_name                = lookup(visibility_config.value, "metric_name", "default-aws-rule-metric")
          sampled_requests_enabled   = lookup(visibility_config.value, "sampled_requests_enabled", true)
        }
      }
    }
  }

  dynamic "rule" {
    for_each = var.ip_set_match_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }

        dynamic "captcha" {
          for_each = rule.value.action == "captcha" ? [1] : []
          content {}
        }

        dynamic "challenge" {
          for_each = rule.value.action == "challenge" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        ip_set_reference_statement {
          arn = rule.value.ip_set_arn
        }
      }

      dynamic "visibility_config" {
        for_each = length(lookup(rule.value, "visibility_config", {})) > 0 ? [rule.value.visibility_config] : []
        content {
          cloudwatch_metrics_enabled = lookup(visibility_config.value, "cloudwatch_metrics_enabled", true)
          metric_name                = lookup(visibility_config.value, "metric_name", "ip-set-rule-metric")
          sampled_requests_enabled   = lookup(visibility_config.value, "sampled_requests_enabled", true)
        }
      }
    }
  }

  dynamic "rule" {
    for_each = var.single_header_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }

        dynamic "captcha" {
          for_each = rule.value.action == "captcha" ? [1] : []
          content {}
        }

        dynamic "challenge" {
          for_each = rule.value.action == "challenge" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        dynamic "byte_match_statement" {
          for_each = length(lookup(rule.value, "search_string", "")) > 0 ? [1] : []
          content {
            field_to_match {
              single_header {
                name = rule.value.header_value
              }
            }
            positional_constraint = "EXACTLY"
            search_string         = rule.value.search_string
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }

        dynamic "regex_match_statement" {
          for_each = length(lookup(rule.value, "regex_string", "")) > 0 ? [1] : []
          content {
            field_to_match {
              single_header {
                name = rule.value.header_value
              }
            }
            regex_string = rule.value.regex_string
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }

      dynamic "visibility_config" {
        for_each = length(lookup(rule.value, "visibility_config", {})) > 0 ? [rule.value.visibility_config] : []
        content {
          cloudwatch_metrics_enabled = lookup(visibility_config.value, "cloudwatch_metrics_enabled", true)
          metric_name                = lookup(visibility_config.value, "metric_name", "default-rule-metric")
          sampled_requests_enabled   = lookup(visibility_config.value, "sampled_requests_enabled", true)
        }
      }
    }
  }

  dynamic "rule" {
    for_each = var.http_method_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }

        dynamic "captcha" {
          for_each = rule.value.action == "captcha" ? [1] : []
          content {}
        }

        dynamic "challenge" {
          for_each = rule.value.action == "challenge" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        dynamic "byte_match_statement" {
          for_each = length(lookup(rule.value, "search_string", "")) > 0 ? [1] : []
          content {
            field_to_match {
              method {}
            }
            positional_constraint = "EXACTLY"
            search_string         = rule.value.search_string
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }

        dynamic "regex_match_statement" {
          for_each = length(lookup(rule.value, "regex_string", "")) > 0 ? [1] : []
          content {
            field_to_match {
              method {}
            }
            regex_string = rule.value.regex_string
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }

      dynamic "visibility_config" {
        for_each = length(lookup(rule.value, "visibility_config", {})) > 0 ? [rule.value.visibility_config] : []
        content {
          cloudwatch_metrics_enabled = lookup(visibility_config.value, "cloudwatch_metrics_enabled", true)
          metric_name                = lookup(visibility_config.value, "metric_name", "default-rule-metric")
          sampled_requests_enabled   = lookup(visibility_config.value, "sampled_requests_enabled", true)
        }
      }
    }
  }

  dynamic "rule" {
    for_each = var.uri_path_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }

        dynamic "captcha" {
          for_each = rule.value.action == "captcha" ? [1] : []
          content {}
        }

        dynamic "challenge" {
          for_each = rule.value.action == "challenge" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        dynamic "byte_match_statement" {
          for_each = length(lookup(rule.value, "search_string", "")) > 0 ? [1] : []
          content {
            field_to_match {
              uri_path {}
            }
            positional_constraint = "EXACTLY"
            search_string         = rule.value.search_string
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }

        dynamic "regex_match_statement" {
          for_each = length(lookup(rule.value, "regex_string", "")) > 0 ? [1] : []
          content {
            field_to_match {
              uri_path {}
            }
            regex_string = rule.value.regex_string
            text_transformation {
              priority = 0
              type     = "NONE"
            }
          }
        }
      }

      dynamic "visibility_config" {
        for_each = length(lookup(rule.value, "visibility_config", {})) > 0 ? [rule.value.visibility_config] : []
        content {
          cloudwatch_metrics_enabled = lookup(visibility_config.value, "cloudwatch_metrics_enabled", true)
          metric_name                = lookup(visibility_config.value, "metric_name", "default-rule-metric")
          sampled_requests_enabled   = lookup(visibility_config.value, "sampled_requests_enabled", true)
        }
      }
    }
  }

  dynamic "rule" {
    for_each = var.geo_match_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }

        dynamic "captcha" {
          for_each = rule.value.action == "captcha" ? [1] : []
          content {}
        }

        dynamic "challenge" {
          for_each = rule.value.action == "challenge" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        geo_match_statement {
          country_codes = rule.value.country_codes
          dynamic "forwarded_ip_config" {
            for_each = length(lookup(rule.value, "fallback_behavior", "")) > 0 ? [1] : []
            content {
              fallback_behavior = rule.value.fallback_behavior
              header_name       = rule.value.header_name
            }
          }
        }
      }

      dynamic "visibility_config" {
        for_each = length(lookup(rule.value, "visibility_config", {})) > 0 ? [rule.value.visibility_config] : []
        content {
          cloudwatch_metrics_enabled = lookup(visibility_config.value, "cloudwatch_metrics_enabled", true)
          metric_name                = lookup(visibility_config.value, "metric_name", "default-rule-metric")
          sampled_requests_enabled   = lookup(visibility_config.value, "sampled_requests_enabled", true)
        }
      }
    }
  }

  dynamic "rule" {
    for_each = var.rate_limit_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }

        dynamic "captcha" {
          for_each = rule.value.action == "captcha" ? [1] : []
          content {}
        }

        dynamic "challenge" {
          for_each = rule.value.action == "challenge" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        rate_based_statement {
          aggregate_key_type    = rule.value.aggregate_key_type
          evaluation_window_sec = rule.value.evaluation_window_sec
          limit                 = rule.value.limit
          dynamic "custom_key" {
            for_each = length(lookup(rule.value, "custom_key", {})) > 0 ? [rule.value.custom_key] : []
            content {
              dynamic "header" {
                for_each = length(lookup(custom_key.value, "header", {})) > 0 ? [custom_key.value.header] : []
                content {
                  name = header.value.name
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }

              dynamic "http_method" {
                for_each = length(lookup(custom_key.value, "http_method", {})) > 0 ? [custom_key.value.http_method] : []
                content {}
              }

              dynamic "uri_path" {
                for_each = length(lookup(custom_key.value, "uri_path", {})) > 0 ? [custom_key.value.uri_path] : []
                content {
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }
            }
          }

          dynamic "custom_key" {
            for_each = contains(keys(rule.value.custom_key), "ip") ? [rule.value.custom_key] : []
            content {
              dynamic "ip" {
                for_each = contains(keys(custom_key.value), "ip") ? [custom_key.value.ip] : []
                content {}
              }
            }
          }

          dynamic "forwarded_ip_config" {
            for_each = length(lookup(rule.value, "forwarded_ip_config", {})) > 0 ? [rule.value.forwarded_ip_config] : []
            content {
              fallback_behavior = forwarded_ip_config.value.fallback_behavior
              header_name       = forwarded_ip_config.valu.header_name
            }
          }

          dynamic "scope_down_statement" {
            for_each = length(lookup(rule.value, "scope_down_statement", {})) > 0 ? [rule.value.scope_down_statement] : []
            content {
              dynamic "byte_match_statement" {
                for_each = length(lookup(scope_down_statement.value, "byte_match_statement", {})) > 0 ? [scope_down_statement.value.byte_match_statement] : []
                content {
                  dynamic "field_to_match" {
                    for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) > 0 ? [byte_match_statement.value.field_to_match] : []
                    content {

                      dynamic "uri_path" {
                        for_each = contains(keys(field_to_match.value), "uri_path") ? [field_to_match.value.uri_path] : []
                        content {}
                      }

                      dynamic "method" {
                        for_each = contains(keys(field_to_match.value), "method") ? [field_to_match.value.method] : []
                        content {}
                      }

                      dynamic "single_header" {
                        for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                        content {
                          name = single_header.value.name
                        }
                      }
                    }
                  }
                  positional_constraint = byte_match_statement.value.positional_constraint
                  search_string         = byte_match_statement.value.search_string
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }

              dynamic "regex_match_statement" {
                for_each = length(lookup(scope_down_statement.value, "regex_match_statement", {})) > 0 ? [scope_down_statement.value.regex_match_statement] : []
                content {
                  dynamic "field_to_match" {
                    for_each = length(lookup(regex_match_statement.value, "field_to_match", {})) > 0 ? [regex_match_statement.value.field_to_match] : []
                    content {

                      dynamic "uri_path" {
                        for_each = length(lookup(field_to_match.value, "uri_path", {})) > 0 ? [field_to_match.value.uri_path] : []
                        content {}
                      }

                      dynamic "method" {
                        for_each = length(lookup(field_to_match.value, "method", {})) > 0 ? [field_to_match.value.method] : []
                        content {}
                      }

                      dynamic "single_header" {
                        for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                        content {
                          name = single_header.value.name
                        }
                      }
                    }
                  }
                  regex_string = regex_match_statement.value.regex_string
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }

              dynamic "geo_match_statement" {
                for_each = length(lookup(scope_down_statement.value, "geo_match_statement", {})) > 0 ? [scope_down_statement.value.geo_match_statement] : []
                content {
                  country_codes = geo_match_statement.value.country_codes
                }
              }

              dynamic "ip_set_reference_statement" {
                for_each = length(lookup(scope_down_statement.value, "ip_set_reference_statement", {})) > 0 ? [scope_down_statement.value.ip_set_reference_statement] : []
                content {
                  arn = ip_set_reference_statement.value.arn
                }
              }
            }
          }
        }
      }

      dynamic "visibility_config" {
        for_each = length(lookup(rule.value, "visibility_config", {})) > 0 ? [rule.value.visibility_config] : []
        content {
          cloudwatch_metrics_enabled = lookup(visibility_config.value, "cloudwatch_metrics_enabled", true)
          metric_name                = lookup(visibility_config.value, "metric_name", "default-rule-metric")
          sampled_requests_enabled   = lookup(visibility_config.value, "sampled_requests_enabled", true)
        }
      }
    }
  }

  dynamic "rule" {
    for_each = var.and_statement_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }

        dynamic "captcha" {
          for_each = rule.value.action == "captcha" ? [1] : []
          content {}
        }

        dynamic "challenge" {
          for_each = rule.value.action == "challenge" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        and_statement {
          dynamic "statement" {
            for_each = rule.value.statements
            content {
              dynamic "byte_match_statement" {
                for_each = length(lookup(statement.value, "byte_match_statement", {})) > 0 ? [statement.value.byte_match_statement] : []
                content {
                  dynamic "field_to_match" {
                    for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) > 0 ? [byte_match_statement.value.field_to_match] : []
                    content {

                      dynamic "uri_path" {
                        for_each = contains(keys(field_to_match.value), "uri_path") ? [field_to_match.value.uri_path] : []
                        content {}
                      }

                      dynamic "method" {
                        for_each = contains(keys(field_to_match.value), "method") ? [field_to_match.value.method] : []
                        content {}
                      }

                      dynamic "single_header" {
                        for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                        content {
                          name = single_header.value.name
                        }
                      }
                    }
                  }
                  positional_constraint = byte_match_statement.value.positional_constraint
                  search_string         = byte_match_statement.value.search_string
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }

              dynamic "regex_match_statement" {
                for_each = length(lookup(statement.value, "regex_match_statement", {})) > 0 ? [statement.value.regex_match_statement] : []
                content {
                  dynamic "field_to_match" {
                    for_each = length(lookup(regex_match_statement.value, "field_to_match", {})) > 0 ? [regex_match_statement.value.field_to_match] : []
                    content {

                      dynamic "uri_path" {
                        for_each = length(lookup(field_to_match.value, "uri_path", {})) > 0 ? [field_to_match.value.uri_path] : []
                        content {}
                      }

                      dynamic "method" {
                        for_each = length(lookup(field_to_match.value, "method", {})) > 0 ? [field_to_match.value.method] : []
                        content {}
                      }

                      dynamic "single_header" {
                        for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                        content {
                          name = single_header.value.name
                        }
                      }
                    }
                  }
                  regex_string = regex_match_statement.value.regex_string
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }

              dynamic "geo_match_statement" {
                for_each = length(lookup(statement.value, "geo_match_statement", {})) > 0 ? [statement.value.geo_match_statement] : []
                content {
                  country_codes = geo_match_statement.value.country_codes
                }
              }

              dynamic "ip_set_reference_statement" {
                for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) > 0 ? [statement.value.ip_set_reference_statement] : []
                content {
                  arn = ip_set_reference_statement.value.arn
                }
              }
            }
          }
        }
      }

      dynamic "visibility_config" {
        for_each = length(lookup(rule.value, "visibility_config", {})) > 0 ? [rule.value.visibility_config] : []
        content {
          cloudwatch_metrics_enabled = lookup(visibility_config.value, "cloudwatch_metrics_enabled", true)
          metric_name                = lookup(visibility_config.value, "metric_name", "default-rule-metric")
          sampled_requests_enabled   = lookup(visibility_config.value, "sampled_requests_enabled", true)
        }
      }
    }
  }

  dynamic "rule" {
    for_each = var.or_statement_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }

        dynamic "captcha" {
          for_each = rule.value.action == "captcha" ? [1] : []
          content {}
        }

        dynamic "challenge" {
          for_each = rule.value.action == "challenge" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        or_statement {
          dynamic "statement" {
            for_each = rule.value.statements
            content {
              dynamic "byte_match_statement" {
                for_each = length(lookup(statement.value, "byte_match_statement", {})) > 0 ? [statement.value.byte_match_statement] : []
                content {
                  dynamic "field_to_match" {
                    for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) > 0 ? [byte_match_statement.value.field_to_match] : []
                    content {

                      dynamic "uri_path" {
                        for_each = contains(keys(field_to_match.value), "uri_path") ? [field_to_match.value.uri_path] : []
                        content {}
                      }

                      dynamic "method" {
                        for_each = contains(keys(field_to_match.value), "method") ? [field_to_match.value.method] : []
                        content {}
                      }

                      dynamic "single_header" {
                        for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                        content {
                          name = single_header.value.name
                        }
                      }
                    }
                  }
                  positional_constraint = byte_match_statement.value.positional_constraint
                  search_string         = byte_match_statement.value.search_string
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }

              dynamic "regex_match_statement" {
                for_each = length(lookup(statement.value, "regex_match_statement", {})) > 0 ? [statement.value.regex_match_statement] : []
                content {
                  dynamic "field_to_match" {
                    for_each = length(lookup(regex_match_statement.value, "field_to_match", {})) > 0 ? [regex_match_statement.value.field_to_match] : []
                    content {

                      dynamic "uri_path" {
                        for_each = length(lookup(field_to_match.value, "uri_path", {})) > 0 ? [field_to_match.value.uri_path] : []
                        content {}
                      }

                      dynamic "method" {
                        for_each = length(lookup(field_to_match.value, "method", {})) > 0 ? [field_to_match.value.method] : []
                        content {}
                      }

                      dynamic "single_header" {
                        for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                        content {
                          name = single_header.value.name
                        }
                      }
                    }
                  }
                  regex_string = regex_match_statement.value.regex_string
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }

              dynamic "geo_match_statement" {
                for_each = length(lookup(statement.value, "geo_match_statement", {})) > 0 ? [statement.value.geo_match_statement] : []
                content {
                  country_codes = geo_match_statement.value.country_codes
                }
              }

              dynamic "ip_set_reference_statement" {
                for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) > 0 ? [statement.value.ip_set_reference_statement] : []
                content {
                  arn = ip_set_reference_statement.value.arn
                }
              }
            }
          }
        }
      }

      dynamic "visibility_config" {
        for_each = length(lookup(rule.value, "visibility_config", {})) > 0 ? [rule.value.visibility_config] : []
        content {
          cloudwatch_metrics_enabled = lookup(visibility_config.value, "cloudwatch_metrics_enabled", true)
          metric_name                = lookup(visibility_config.value, "metric_name", "default-rule-metric")
          sampled_requests_enabled   = lookup(visibility_config.value, "sampled_requests_enabled", true)
        }
      }
    }
  }

  dynamic "rule" {
    for_each = var.not_statement_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }

        dynamic "captcha" {
          for_each = rule.value.action == "captcha" ? [1] : []
          content {}
        }

        dynamic "challenge" {
          for_each = rule.value.action == "challenge" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        not_statement {
          statement {
            dynamic "byte_match_statement" {
              for_each = length(lookup(rule.value, "byte_match_statement", {})) > 0 ? [rule.value.byte_match_statement] : []
              content {
                dynamic "field_to_match" {
                  for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) > 0 ? [byte_match_statement.value.field_to_match] : []
                  content {

                    dynamic "uri_path" {
                      for_each = contains(keys(field_to_match.value), "uri_path") ? [field_to_match.value.uri_path] : []
                      content {}
                    }

                    dynamic "method" {
                      for_each = contains(keys(field_to_match.value), "method") ? [field_to_match.value.method] : []
                      content {}
                    }

                    dynamic "single_header" {
                      for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                      content {
                        name = single_header.value.name
                      }
                    }
                  }
                }
                positional_constraint = byte_match_statement.value.positional_constraint
                search_string         = byte_match_statement.value.search_string
                text_transformation {
                  priority = 0
                  type     = "NONE"
                }
              }
            }

            dynamic "regex_match_statement" {
              for_each = length(lookup(rule.value, "regex_match_statement", {})) > 0 ? [rule.value.regex_match_statement] : []
              content {
                dynamic "field_to_match" {
                  for_each = length(lookup(regex_match_statement.value, "field_to_match", {})) > 0 ? [regex_match_statement.value.field_to_match] : []
                  content {

                    dynamic "uri_path" {
                      for_each = length(lookup(field_to_match.value, "uri_path", {})) > 0 ? [field_to_match.value.uri_path] : []
                      content {}
                    }

                    dynamic "method" {
                      for_each = length(lookup(field_to_match.value, "method", {})) > 0 ? [field_to_match.value.method] : []
                      content {}
                    }

                    dynamic "single_header" {
                      for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                      content {
                        name = single_header.value.name
                      }
                    }
                  }
                }
                regex_string = regex_match_statement.value.regex_string
                text_transformation {
                  priority = 0
                  type     = "NONE"
                }
              }
            }

            dynamic "geo_match_statement" {
              for_each = length(lookup(rule.value, "geo_match_statement", {})) > 0 ? [rule.value.geo_match_statement] : []
              content {
                country_codes = geo_match_statement.value.country_codes
              }
            }

            dynamic "ip_set_reference_statement" {
              for_each = length(lookup(rule.value, "ip_set_reference_statement", {})) > 0 ? [rule.value.ip_set_reference_statement] : []
              content {
                arn = ip_set_reference_statement.value.arn
              }
            }
          }
        }
      }

      dynamic "visibility_config" {
        for_each = length(lookup(rule.value, "visibility_config", {})) > 0 ? [rule.value.visibility_config] : []
        content {
          cloudwatch_metrics_enabled = lookup(visibility_config.value, "cloudwatch_metrics_enabled", true)
          metric_name                = lookup(visibility_config.value, "metric_name", "default-rule-metric")
          sampled_requests_enabled   = lookup(visibility_config.value, "sampled_requests_enabled", true)
        }
      }
    }
  }

  dynamic "rule" {
    for_each = var.and_not_statement_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }

        dynamic "captcha" {
          for_each = rule.value.action == "captcha" ? [1] : []
          content {}
        }

        dynamic "challenge" {
          for_each = rule.value.action == "challenge" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        and_statement {
          dynamic "statement" {
            for_each = rule.value.statements
            content {
              dynamic "byte_match_statement" {
                for_each = length(lookup(statement.value, "byte_match_statement", {})) > 0 ? [statement.value.byte_match_statement] : []
                content {
                  dynamic "field_to_match" {
                    for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) > 0 ? [byte_match_statement.value.field_to_match] : []
                    content {

                      dynamic "uri_path" {
                        for_each = contains(keys(field_to_match.value), "uri_path") ? [field_to_match.value.uri_path] : []
                        content {}
                      }

                      dynamic "method" {
                        for_each = contains(keys(field_to_match.value), "method") ? [field_to_match.value.method] : []
                        content {}
                      }

                      dynamic "single_header" {
                        for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                        content {
                          name = single_header.value.name
                        }
                      }
                    }
                  }
                  positional_constraint = byte_match_statement.value.positional_constraint
                  search_string         = byte_match_statement.value.search_string
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }

              dynamic "regex_match_statement" {
                for_each = length(lookup(statement.value, "regex_match_statement", {})) > 0 ? [statement.value.regex_match_statement] : []
                content {
                  dynamic "field_to_match" {
                    for_each = length(lookup(regex_match_statement.value, "field_to_match", {})) > 0 ? [regex_match_statement.value.field_to_match] : []
                    content {

                      dynamic "uri_path" {
                        for_each = length(lookup(field_to_match.value, "uri_path", {})) > 0 ? [field_to_match.value.uri_path] : []
                        content {}
                      }

                      dynamic "method" {
                        for_each = length(lookup(field_to_match.value, "method", {})) > 0 ? [field_to_match.value.method] : []
                        content {}
                      }

                      dynamic "single_header" {
                        for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                        content {
                          name = single_header.value.name
                        }
                      }
                    }
                  }
                  regex_string = regex_match_statement.value.regex_string
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }

              dynamic "geo_match_statement" {
                for_each = length(lookup(statement.value, "geo_match_statement", {})) > 0 ? [statement.value.geo_match_statement] : []
                content {
                  country_codes = geo_match_statement.value.country_codes
                }
              }

              dynamic "ip_set_reference_statement" {
                for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) > 0 ? [statement.value.ip_set_reference_statement] : []
                content {
                  arn = ip_set_reference_statement.value.arn
                }
              }

              dynamic "not_statement" {
                for_each = length(lookup(statement.value, "not_statement", {})) > 0 ? [statement.value.not_statement] : []
                content {
                  statement {
                    dynamic "byte_match_statement" {
                      for_each = length(lookup(not_statement.value, "byte_match_statement", {})) > 0 ? [not_statement.value.byte_match_statement] : []
                      content {
                        dynamic "field_to_match" {
                          for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) > 0 ? [byte_match_statement.value.field_to_match] : []
                          content {

                            dynamic "uri_path" {
                              for_each = contains(keys(field_to_match.value), "uri_path") ? [field_to_match.value.uri_path] : []
                              content {}
                            }

                            dynamic "method" {
                              for_each = contains(keys(field_to_match.value), "method") ? [field_to_match.value.method] : []
                              content {}
                            }

                            dynamic "single_header" {
                              for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                              content {
                                name = single_header.value.name
                              }
                            }
                          }
                        }
                        positional_constraint = byte_match_statement.value.positional_constraint
                        search_string         = byte_match_statement.value.search_string
                        text_transformation {
                          priority = 0
                          type     = "NONE"
                        }
                      }
                    }

                    dynamic "regex_match_statement" {
                      for_each = length(lookup(not_statement.value, "regex_match_statement", {})) > 0 ? [not_statement.value.regex_match_statement] : []
                      content {
                        dynamic "field_to_match" {
                          for_each = length(lookup(regex_match_statement.value, "field_to_match", {})) > 0 ? [regex_match_statement.value.field_to_match] : []
                          content {

                            dynamic "uri_path" {
                              for_each = length(lookup(field_to_match.value, "uri_path", {})) > 0 ? [field_to_match.value.uri_path] : []
                              content {}
                            }

                            dynamic "method" {
                              for_each = length(lookup(field_to_match.value, "method", {})) > 0 ? [field_to_match.value.method] : []
                              content {}
                            }

                            dynamic "single_header" {
                              for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                              content {
                                name = single_header.value.name
                              }
                            }
                          }
                        }
                        regex_string = regex_match_statement.value.regex_string
                        text_transformation {
                          priority = 0
                          type     = "NONE"
                        }
                      }
                    }

                    dynamic "geo_match_statement" {
                      for_each = length(lookup(not_statement.value, "geo_match_statement", {})) > 0 ? [not_statement.value.geo_match_statement] : []
                      content {
                        country_codes = geo_match_statement.value.country_codes
                      }
                    }

                    dynamic "ip_set_reference_statement" {
                      for_each = length(lookup(not_statement.value, "ip_set_reference_statement", {})) > 0 ? [not_statement.value.ip_set_reference_statement] : []
                      content {
                        arn = ip_set_reference_statement.value.arn
                      }
                    }

                    dynamic "or_statement" {
                      for_each = length(lookup(not_statement.value, "or_statement", {})) > 0 ? [not_statement.value.or_statement] : []
                      content {
                        dynamic "statement" {
                          for_each = or_statement.value.statements
                          content {
                            dynamic "byte_match_statement" {
                              for_each = length(lookup(statement.value, "byte_match_statement", {})) > 0 ? [statement.value.byte_match_statement] : []
                              content {
                                dynamic "field_to_match" {
                                  for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) > 0 ? [byte_match_statement.value.field_to_match] : []
                                  content {

                                    dynamic "uri_path" {
                                      for_each = contains(keys(field_to_match.value), "uri_path") ? [field_to_match.value.uri_path] : []
                                      content {}
                                    }

                                    dynamic "method" {
                                      for_each = contains(keys(field_to_match.value), "method") ? [field_to_match.value.method] : []
                                      content {}
                                    }

                                    dynamic "single_header" {
                                      for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                                      content {
                                        name = single_header.value.name
                                      }
                                    }
                                  }
                                }
                                positional_constraint = byte_match_statement.value.positional_constraint
                                search_string         = byte_match_statement.value.search_string
                                text_transformation {
                                  priority = 0
                                  type     = "NONE"
                                }
                              }
                            }

                            dynamic "regex_match_statement" {
                              for_each = length(lookup(statement.value, "regex_match_statement", {})) > 0 ? [statement.value.regex_match_statement] : []
                              content {
                                dynamic "field_to_match" {
                                  for_each = length(lookup(regex_match_statement.value, "field_to_match", {})) > 0 ? [regex_match_statement.value.field_to_match] : []
                                  content {

                                    dynamic "uri_path" {
                                      for_each = length(lookup(field_to_match.value, "uri_path", {})) > 0 ? [field_to_match.value.uri_path] : []
                                      content {}
                                    }

                                    dynamic "method" {
                                      for_each = length(lookup(field_to_match.value, "method", {})) > 0 ? [field_to_match.value.method] : []
                                      content {}
                                    }

                                    dynamic "single_header" {
                                      for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                                      content {
                                        name = single_header.value.name
                                      }
                                    }
                                  }
                                }
                                regex_string = regex_match_statement.value.regex_string
                                text_transformation {
                                  priority = 0
                                  type     = "NONE"
                                }
                              }
                            }

                            dynamic "geo_match_statement" {
                              for_each = length(lookup(statement.value, "geo_match_statement", {})) > 0 ? [statement.value.geo_match_statement] : []
                              content {
                                country_codes = geo_match_statement.value.country_codes
                              }
                            }

                            dynamic "ip_set_reference_statement" {
                              for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) > 0 ? [statement.value.ip_set_reference_statement] : []
                              content {
                                arn = ip_set_reference_statement.value.arn
                              }
                            }
                          }
                        }
                      }
                    }

                    dynamic "and_statement" {
                      for_each = length(lookup(not_statement.value, "and_statement", {})) > 0 ? [not_statement.value.and_statement] : []
                      content {
                        dynamic "statement" {
                          for_each = and_statement.value.statements
                          content {
                            dynamic "byte_match_statement" {
                              for_each = length(lookup(statement.value, "byte_match_statement", {})) > 0 ? [statement.value.byte_match_statement] : []
                              content {
                                dynamic "field_to_match" {
                                  for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) > 0 ? [byte_match_statement.value.field_to_match] : []
                                  content {

                                    dynamic "uri_path" {
                                      for_each = contains(keys(field_to_match.value), "uri_path") ? [field_to_match.value.uri_path] : []
                                      content {}
                                    }

                                    dynamic "method" {
                                      for_each = contains(keys(field_to_match.value), "method") ? [field_to_match.value.method] : []
                                      content {}
                                    }

                                    dynamic "single_header" {
                                      for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                                      content {
                                        name = single_header.value.name
                                      }
                                    }
                                  }
                                }
                                positional_constraint = byte_match_statement.value.positional_constraint
                                search_string         = byte_match_statement.value.search_string
                                text_transformation {
                                  priority = 0
                                  type     = "NONE"
                                }
                              }
                            }

                            dynamic "regex_match_statement" {
                              for_each = length(lookup(statement.value, "regex_match_statement", {})) > 0 ? [statement.value.regex_match_statement] : []
                              content {
                                dynamic "field_to_match" {
                                  for_each = length(lookup(regex_match_statement.value, "field_to_match", {})) > 0 ? [regex_match_statement.value.field_to_match] : []
                                  content {

                                    dynamic "uri_path" {
                                      for_each = length(lookup(field_to_match.value, "uri_path", {})) > 0 ? [field_to_match.value.uri_path] : []
                                      content {}
                                    }

                                    dynamic "method" {
                                      for_each = length(lookup(field_to_match.value, "method", {})) > 0 ? [field_to_match.value.method] : []
                                      content {}
                                    }

                                    dynamic "single_header" {
                                      for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                                      content {
                                        name = single_header.value.name
                                      }
                                    }
                                  }
                                }
                                regex_string = regex_match_statement.value.regex_string
                                text_transformation {
                                  priority = 0
                                  type     = "NONE"
                                }
                              }
                            }

                            dynamic "geo_match_statement" {
                              for_each = length(lookup(statement.value, "geo_match_statement", {})) > 0 ? [statement.value.geo_match_statement] : []
                              content {
                                country_codes = geo_match_statement.value.country_codes
                              }
                            }

                            dynamic "ip_set_reference_statement" {
                              for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) > 0 ? [statement.value.ip_set_reference_statement] : []
                              content {
                                arn = ip_set_reference_statement.value.arn
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "visibility_config" {
        for_each = length(lookup(rule.value, "visibility_config", {})) > 0 ? [rule.value.visibility_config] : []
        content {
          cloudwatch_metrics_enabled = lookup(visibility_config.value, "cloudwatch_metrics_enabled", true)
          metric_name                = lookup(visibility_config.value, "metric_name", "default-rule-metric")
          sampled_requests_enabled   = lookup(visibility_config.value, "sampled_requests_enabled", true)
        }
      }
    }
  }

  dynamic "rule" {
    for_each = var.or_not_statement_rules
    content {
      name     = rule.value.name
      priority = rule.value.priority

      action {
        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {}
        }

        dynamic "captcha" {
          for_each = rule.value.action == "captcha" ? [1] : []
          content {}
        }

        dynamic "challenge" {
          for_each = rule.value.action == "challenge" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }
      }

      statement {
        or_statement {
          dynamic "statement" {
            for_each = rule.value.statements
            content {
              dynamic "byte_match_statement" {
                for_each = length(lookup(statement.value, "byte_match_statement", {})) > 0 ? [statement.value.byte_match_statement] : []
                content {
                  dynamic "field_to_match" {
                    for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) > 0 ? [byte_match_statement.value.field_to_match] : []
                    content {

                      dynamic "uri_path" {
                        for_each = contains(keys(field_to_match.value), "uri_path") ? [field_to_match.value.uri_path] : []
                        content {}
                      }

                      dynamic "method" {
                        for_each = contains(keys(field_to_match.value), "method") ? [field_to_match.value.method] : []
                        content {}
                      }

                      dynamic "single_header" {
                        for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                        content {
                          name = single_header.value.name
                        }
                      }
                    }
                  }
                  positional_constraint = byte_match_statement.value.positional_constraint
                  search_string         = byte_match_statement.value.search_string
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }

              dynamic "regex_match_statement" {
                for_each = length(lookup(statement.value, "regex_match_statement", {})) > 0 ? [statement.value.regex_match_statement] : []
                content {
                  dynamic "field_to_match" {
                    for_each = length(lookup(regex_match_statement.value, "field_to_match", {})) > 0 ? [regex_match_statement.value.field_to_match] : []
                    content {

                      dynamic "uri_path" {
                        for_each = length(lookup(field_to_match.value, "uri_path", {})) > 0 ? [field_to_match.value.uri_path] : []
                        content {}
                      }

                      dynamic "method" {
                        for_each = length(lookup(field_to_match.value, "method", {})) > 0 ? [field_to_match.value.method] : []
                        content {}
                      }

                      dynamic "single_header" {
                        for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                        content {
                          name = single_header.value.name
                        }
                      }
                    }
                  }
                  regex_string = regex_match_statement.value.regex_string
                  text_transformation {
                    priority = 0
                    type     = "NONE"
                  }
                }
              }

              dynamic "geo_match_statement" {
                for_each = length(lookup(statement.value, "geo_match_statement", {})) > 0 ? [statement.value.geo_match_statement] : []
                content {
                  country_codes = geo_match_statement.value.country_codes
                }
              }

              dynamic "ip_set_reference_statement" {
                for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) > 0 ? [statement.value.ip_set_reference_statement] : []
                content {
                  arn = ip_set_reference_statement.value.arn
                }
              }

              dynamic "not_statement" {
                for_each = length(lookup(statement.value, "not_statement", {})) > 0 ? [statement.value.not_statement] : []
                content {
                  statement {
                    dynamic "byte_match_statement" {
                      for_each = length(lookup(not_statement.value, "byte_match_statement", {})) > 0 ? [not_statement.value.byte_match_statement] : []
                      content {
                        dynamic "field_to_match" {
                          for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) > 0 ? [byte_match_statement.value.field_to_match] : []
                          content {

                            dynamic "uri_path" {
                              for_each = contains(keys(field_to_match.value), "uri_path") ? [field_to_match.value.uri_path] : []
                              content {}
                            }

                            dynamic "method" {
                              for_each = contains(keys(field_to_match.value), "method") ? [field_to_match.value.method] : []
                              content {}
                            }

                            dynamic "single_header" {
                              for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                              content {
                                name = single_header.value.name
                              }
                            }
                          }
                        }
                        positional_constraint = byte_match_statement.value.positional_constraint
                        search_string         = byte_match_statement.value.search_string
                        text_transformation {
                          priority = 0
                          type     = "NONE"
                        }
                      }
                    }

                    dynamic "regex_match_statement" {
                      for_each = length(lookup(not_statement.value, "regex_match_statement", {})) > 0 ? [not_statement.value.regex_match_statement] : []
                      content {
                        dynamic "field_to_match" {
                          for_each = length(lookup(regex_match_statement.value, "field_to_match", {})) > 0 ? [regex_match_statement.value.field_to_match] : []
                          content {

                            dynamic "uri_path" {
                              for_each = length(lookup(field_to_match.value, "uri_path", {})) > 0 ? [field_to_match.value.uri_path] : []
                              content {}
                            }

                            dynamic "method" {
                              for_each = length(lookup(field_to_match.value, "method", {})) > 0 ? [field_to_match.value.method] : []
                              content {}
                            }

                            dynamic "single_header" {
                              for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                              content {
                                name = single_header.value.name
                              }
                            }
                          }
                        }
                        regex_string = regex_match_statement.value.regex_string
                        text_transformation {
                          priority = 0
                          type     = "NONE"
                        }
                      }
                    }

                    dynamic "geo_match_statement" {
                      for_each = length(lookup(not_statement.value, "geo_match_statement", {})) > 0 ? [not_statement.value.geo_match_statement] : []
                      content {
                        country_codes = geo_match_statement.value.country_codes
                      }
                    }

                    dynamic "ip_set_reference_statement" {
                      for_each = length(lookup(not_statement.value, "ip_set_reference_statement", {})) > 0 ? [not_statement.value.ip_set_reference_statement] : []
                      content {
                        arn = ip_set_reference_statement.value.arn
                      }
                    }

                    dynamic "or_statement" {
                      for_each = length(lookup(not_statement.value, "or_statement", {})) > 0 ? [not_statement.value.or_statement] : []
                      content {
                        dynamic "statement" {
                          for_each = or_statement.value.statements
                          content {
                            dynamic "byte_match_statement" {
                              for_each = length(lookup(statement.value, "byte_match_statement", {})) > 0 ? [statement.value.byte_match_statement] : []
                              content {
                                dynamic "field_to_match" {
                                  for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) > 0 ? [byte_match_statement.value.field_to_match] : []
                                  content {

                                    dynamic "uri_path" {
                                      for_each = contains(keys(field_to_match.value), "uri_path") ? [field_to_match.value.uri_path] : []
                                      content {}
                                    }

                                    dynamic "method" {
                                      for_each = contains(keys(field_to_match.value), "method") ? [field_to_match.value.method] : []
                                      content {}
                                    }

                                    dynamic "single_header" {
                                      for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                                      content {
                                        name = single_header.value.name
                                      }
                                    }
                                  }
                                }
                                positional_constraint = byte_match_statement.value.positional_constraint
                                search_string         = byte_match_statement.value.search_string
                                text_transformation {
                                  priority = 0
                                  type     = "NONE"
                                }
                              }
                            }

                            dynamic "regex_match_statement" {
                              for_each = length(lookup(statement.value, "regex_match_statement", {})) > 0 ? [statement.value.regex_match_statement] : []
                              content {
                                dynamic "field_to_match" {
                                  for_each = length(lookup(regex_match_statement.value, "field_to_match", {})) > 0 ? [regex_match_statement.value.field_to_match] : []
                                  content {

                                    dynamic "uri_path" {
                                      for_each = length(lookup(field_to_match.value, "uri_path", {})) > 0 ? [field_to_match.value.uri_path] : []
                                      content {}
                                    }

                                    dynamic "method" {
                                      for_each = length(lookup(field_to_match.value, "method", {})) > 0 ? [field_to_match.value.method] : []
                                      content {}
                                    }

                                    dynamic "single_header" {
                                      for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                                      content {
                                        name = single_header.value.name
                                      }
                                    }
                                  }
                                }
                                regex_string = regex_match_statement.value.regex_string
                                text_transformation {
                                  priority = 0
                                  type     = "NONE"
                                }
                              }
                            }

                            dynamic "geo_match_statement" {
                              for_each = length(lookup(statement.value, "geo_match_statement", {})) > 0 ? [statement.value.geo_match_statement] : []
                              content {
                                country_codes = geo_match_statement.value.country_codes
                              }
                            }

                            dynamic "ip_set_reference_statement" {
                              for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) > 0 ? [statement.value.ip_set_reference_statement] : []
                              content {
                                arn = ip_set_reference_statement.value.arn
                              }
                            }
                          }
                        }
                      }
                    }

                    dynamic "and_statement" {
                      for_each = length(lookup(not_statement.value, "and_statement", {})) > 0 ? [not_statement.value.and_statement] : []
                      content {
                        dynamic "statement" {
                          for_each = and_statement.value.statements
                          content {
                            dynamic "byte_match_statement" {
                              for_each = length(lookup(statement.value, "byte_match_statement", {})) > 0 ? [statement.value.byte_match_statement] : []
                              content {
                                dynamic "field_to_match" {
                                  for_each = length(lookup(byte_match_statement.value, "field_to_match", {})) > 0 ? [byte_match_statement.value.field_to_match] : []
                                  content {

                                    dynamic "uri_path" {
                                      for_each = contains(keys(field_to_match.value), "uri_path") ? [field_to_match.value.uri_path] : []
                                      content {}
                                    }

                                    dynamic "method" {
                                      for_each = contains(keys(field_to_match.value), "method") ? [field_to_match.value.method] : []
                                      content {}
                                    }

                                    dynamic "single_header" {
                                      for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                                      content {
                                        name = single_header.value.name
                                      }
                                    }
                                  }
                                }
                                positional_constraint = byte_match_statement.value.positional_constraint
                                search_string         = byte_match_statement.value.search_string
                                text_transformation {
                                  priority = 0
                                  type     = "NONE"
                                }
                              }
                            }

                            dynamic "regex_match_statement" {
                              for_each = length(lookup(statement.value, "regex_match_statement", {})) > 0 ? [statement.value.regex_match_statement] : []
                              content {
                                dynamic "field_to_match" {
                                  for_each = length(lookup(regex_match_statement.value, "field_to_match", {})) > 0 ? [regex_match_statement.value.field_to_match] : []
                                  content {

                                    dynamic "uri_path" {
                                      for_each = length(lookup(field_to_match.value, "uri_path", {})) > 0 ? [field_to_match.value.uri_path] : []
                                      content {}
                                    }

                                    dynamic "method" {
                                      for_each = length(lookup(field_to_match.value, "method", {})) > 0 ? [field_to_match.value.method] : []
                                      content {}
                                    }

                                    dynamic "single_header" {
                                      for_each = length(lookup(field_to_match.value, "single_header", {})) > 0 ? [field_to_match.value.single_header] : []
                                      content {
                                        name = single_header.value.name
                                      }
                                    }
                                  }
                                }
                                regex_string = regex_match_statement.value.regex_string
                                text_transformation {
                                  priority = 0
                                  type     = "NONE"
                                }
                              }
                            }

                            dynamic "geo_match_statement" {
                              for_each = length(lookup(statement.value, "geo_match_statement", {})) > 0 ? [statement.value.geo_match_statement] : []
                              content {
                                country_codes = geo_match_statement.value.country_codes
                              }
                            }

                            dynamic "ip_set_reference_statement" {
                              for_each = length(lookup(statement.value, "ip_set_reference_statement", {})) > 0 ? [statement.value.ip_set_reference_statement] : []
                              content {
                                arn = ip_set_reference_statement.value.arn
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "visibility_config" {
        for_each = length(lookup(rule.value, "visibility_config", {})) > 0 ? [rule.value.visibility_config] : []
        content {
          cloudwatch_metrics_enabled = lookup(visibility_config.value, "cloudwatch_metrics_enabled", true)
          metric_name                = lookup(visibility_config.value, "metric_name", "default-rule-metric")
          sampled_requests_enabled   = lookup(visibility_config.value, "sampled_requests_enabled", true)
        }
      }
    }
  }
}
