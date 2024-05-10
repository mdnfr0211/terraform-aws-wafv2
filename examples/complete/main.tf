module "waf" {
  source = "../.."

  acl_name = "exampleACL"
  scope    = "REGIONAL"

  aws_managed_rules = [
    {
      name                 = "AWSManagedRulesAmazonIpReputationList",
      priority             = 0
      rule_action_override = [],
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    },
    {
      name     = "AWSManagedRulesCommonRuleSet",
      priority = 1
      rule_action_override = [
        {
          name          = "CrossSiteScripting_BODY",
          action_to_use = "allow"
        },
        {
          name          = "SizeRestrictions_BODY",
          action_to_use = "allow"
        }
      ],
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    }
  ]

  ip_set_match_rules = [
    {
      name       = "IPSetRule"
      priority   = 2
      ip_set_arn = "arn:aws:wafv2:ap-southeast-1:453752871997:regional/ipset/test/493d5385-7487-4e65-81f3-c9427e2c10a9"
      action     = "allow"
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    }
  ]

  single_header_rules = [
    {
      name          = "HeaderRule1"
      priority      = 3
      action        = "block"
      header_value  = "host"
      search_string = "example.com"
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    },
    {
      name         = "HeaderRule2"
      priority     = 4
      action       = "allow"
      header_value = "host"
      regex_string = "(example.com)"
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    }
  ]

  http_method_rules = [
    {
      name          = "MethodRule1"
      priority      = 5
      action        = "block"
      search_string = "PUT"
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    },
    {
      name         = "MethodRule2"
      priority     = 6
      action       = "allow"
      regex_string = "(GET|POST)"
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    }
  ]

  uri_path_rules = [
    {
      name          = "PathRule1"
      priority      = 7
      action        = "block"
      search_string = "/admin"
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    },
    {
      name         = "PathRule2"
      priority     = 8
      action       = "allow"
      regex_string = "(^\\/admin\\/test)"
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    }
  ]

  geo_match_rules = [
    {
      name          = "GeoMatchRule"
      priority      = 9
      action        = "count"
      country_codes = ["IN"]
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    }
  ]

  rate_limit_rules = [
    {
      name                  = "RateLimitRule"
      priority              = 10
      action                = "count"
      aggregate_key_type    = "CUSTOM_KEYS"
      evaluation_window_sec = 60
      limit                 = 100
      custom_key = {
        header = {
          name = "Host"
        }
        ip = {}
      }
      match_statement = {
        byte_match_statement = {
          field_to_match = {
            method = {}
          }
          positional_constraint = "EXACTLY"
          search_string         = "test"
        }
      }
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    }
  ]

  and_statement_rules = [
    {
      name     = "AndStatementRule"
      priority = 11
      action   = "count"
      statements = [
        {
          byte_match_statement = {
            field_to_match = {
              method = {}
            }
            positional_constraint = "EXACTLY"
            search_string         = "GET"
          }
        },
        {
          geo_match_statement = {
            country_codes = ["IN"]
          }
        }
      ]
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    }
  ]

  or_statement_rules = [
    {
      name     = "OrStatementRule"
      priority = 12
      action   = "count"
      statements = [
        {
          byte_match_statement = {
            field_to_match = {
              method = {}
            }
            positional_constraint = "EXACTLY"
            search_string         = "GET"
          }
        },
        {
          geo_match_statement = {
            country_codes = ["IN"]
          }
        }
      ]
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    }
  ]

  not_statement_rules = [
    {
      name     = "NotStatementRule"
      priority = 13
      action   = "count"
      byte_match_statement = {
        field_to_match = {
          method = {}
        }
        positional_constraint = "EXACTLY"
        search_string         = "GET"
      }

      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    }
  ]

  and_not_statement_rules = [
    {
      name     = "AndNotStatementRule"
      priority = 14
      action   = "count"
      statements = [
        {
          byte_match_statement = {
            field_to_match = {
              method = {}
            }
            positional_constraint = "EXACTLY"
            search_string         = "GET"
          }
        },
        {
          not_statement = {
            geo_match_statement = {
              country_codes = ["IN"]
            }
          }
        }
      ]
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    },
    {
      name     = "AndNotStatementRule2"
      priority = 15
      action   = "count"
      statements = [
        {
          byte_match_statement = {
            field_to_match = {
              method = {}
            }
            positional_constraint = "EXACTLY"
            search_string         = "GET"
          }
        },
        {
          not_statement = {
            or_statement = {
              statements = [
                {
                  byte_match_statement = {
                    field_to_match = {
                      method = {}
                    }
                    positional_constraint = "EXACTLY"
                    search_string         = "GET"
                  }
                },
                {
                  geo_match_statement = {
                    country_codes = ["IN"]
                  }
                }
              ]
            }
          }
        }
      ]
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    },
    {
      name     = "AndNotStatementRule3"
      priority = 16
      action   = "count"
      statements = [
        {
          byte_match_statement = {
            field_to_match = {
              method = {}
            }
            positional_constraint = "EXACTLY"
            search_string         = "GET"
          }
        },
        {
          not_statement = {
            and_statement = {
              statements = [
                {
                  byte_match_statement = {
                    field_to_match = {
                      method = {}
                    }
                    positional_constraint = "EXACTLY"
                    search_string         = "GET"
                  }
                },
                {
                  geo_match_statement = {
                    country_codes = ["IN"]
                  }
                }
              ]
            }
          }
        }
      ]
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    }
  ]

  or_not_statement_rules = [
    {
      name     = "OrNotStatementRule"
      priority = 17
      action   = "count"
      statements = [
        {
          byte_match_statement = {
            field_to_match = {
              method = {}
            }
            positional_constraint = "EXACTLY"
            search_string         = "GET"
          }
        },
        {
          not_statement = {
            geo_match_statement = {
              country_codes = ["IN"]
            }
          }
        }
      ]
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    },
    {
      name     = "OrNotStatementRule2"
      priority = 18
      action   = "count"
      statements = [
        {
          byte_match_statement = {
            field_to_match = {
              method = {}
            }
            positional_constraint = "EXACTLY"
            search_string         = "GET"
          }
        },
        {
          not_statement = {
            or_statement = {
              statements = [
                {
                  byte_match_statement = {
                    field_to_match = {
                      method = {}
                    }
                    positional_constraint = "EXACTLY"
                    search_string         = "GET"
                  }
                },
                {
                  geo_match_statement = {
                    country_codes = ["IN"]
                  }
                }
              ]
            }
          }
        }
      ]
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    },
    {
      name     = "OrNotStatementRule3"
      priority = 19
      action   = "count"
      statements = [
        {
          byte_match_statement = {
            field_to_match = {
              method = {}
            }
            positional_constraint = "EXACTLY"
            search_string         = "GET"
          }
        },
        {
          not_statement = {
            and_statement = {
              statements = [
                {
                  byte_match_statement = {
                    field_to_match = {
                      method = {}
                    }
                    positional_constraint = "EXACTLY"
                    search_string         = "GET"
                  }
                },
                {
                  geo_match_statement = {
                    country_codes = ["IN"]
                  }
                }
              ]
            }
          }
        }
      ]
      visibility_config = {
        cloudwatch_metrics_enabled = false
        sampled_requests_enabled   = false
      }
    }
  ]
}
