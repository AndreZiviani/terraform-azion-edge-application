locals {
  origins = {
    for origin, settings in var.origins :
    settings.name => settings
  }

  caches = {
    for route, route_config in var.routes :
    route_config.path => route_config.cache_settings if route_config.cache_enabled
  }

  rules = merge([
    for route, route_config in var.routes : {
      for rule, rule_config in route_config.rules :
      "${route_config.path}_${rule_config.name}" => {
        config = merge(rule_config, {
          behaviors = concat(
            # inject origin
            [{
              name   = "set_origin",
              target = azion_edge_application_origin.this[route_config.origin_name].id
            }],
            # inject or bypass cache
            route_config.cache_enabled ?
            [{
              name   = "set_cache_policy",
              target = azion_edge_application_cache_setting.this[route_config.path].id
            }] :
            [{
              name   = "bypass_cache_phase"
              target = ""
            }],
            rule_config.behaviors
          )
        })
        path = route_config.path
      }
    }
  ]...)

}
