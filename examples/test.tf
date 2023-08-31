module "test" {
  source = "../"
  edge_application = {
    name              = "example"
    supported_ciphers = "all"
    delivery_protocol = "http,https"
    http_port         = [80]
    https_port        = [443]
    caching           = true
    #minimum_tls_version      = "tls_1_3"
    #http3             = true
    #application_acceleration = true

    debug_rules              = false
    edge_firewall            = false
    edge_functions           = false
    image_optimization       = false
    l2_caching               = false
    load_balancer            = false
    device_detection         = false
    web_application_firewall = false
    raw_logs                 = false
  }

  origins = [
    {
      name        = "main-origin"
      origin_type = "single_origin"
      addresses = [
        {
          address = "origin1.example.org"
        }
      ]
      origin_protocol_policy = "https"
      host_header            = "$${host}"
    },
    {
      name        = "another-origin"
      origin_type = "single_origin"
      addresses = [
        {
          address = "origin2.example.org"
        }
      ]
      origin_protocol_policy = "https"
      host_header            = "$${host}"
    },
  ]

  routes = [
    {
      path        = "/example"
      description = "Example Route"
      origin_name = "main-origin"
      rules = [
        {
          name        = "bypass-cache"
          description = "Ignore cache here"
          phase       = "request"
          criteria = [
            {
              entries = [
                {
                  variable    = "$${uri}"
                  operator    = "is_equal"
                  conditional = "if"
                  input_value = "/example"
                }
              ]
            }
          ]
          behaviors = [
            {
              name   = "bypass_cache"
              target = ""
            },
            {
              name   = "deliver"
              target = ""
            }
          ]
        },
      ]
      cache_enabled = true
      cache_settings = {
        name                           = "Terraform New Cache Setting Example"
        browser_cache_settings         = "override"
        cdn_cache_settings             = "override"
        cdn_cache_settings_maximum_ttl = 13660
        cache_by_query_string          = "ignore"
        cache_by_cookies               = "ignore"
        adaptive_delivery_action       = "ignore"
        enable_stale_cache             = true
      }
    }
  ]
}
