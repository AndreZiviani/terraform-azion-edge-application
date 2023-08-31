resource "azion_edge_application_main_setting" "this" {
  edge_application = var.edge_application
}

resource "azion_edge_application_origin" "this" {
  for_each            = local.origins
  edge_application_id = azion_edge_application_main_setting.this.edge_application.application_id
  depends_on = [
    azion_edge_application_main_setting.this
  ]

  origin = each.value
}

resource "azion_edge_application_cache_setting" "this" {
  for_each            = local.caches
  edge_application_id = azion_edge_application_main_setting.this.edge_application.application_id
  depends_on = [
    azion_edge_application_main_setting.this
  ]
  cache_settings = each.value
}

resource "azion_edge_application_rule_engine" "this" {
  for_each            = local.rules
  edge_application_id = azion_edge_application_main_setting.this.edge_application.application_id
  depends_on = [
    azion_edge_application_main_setting.this,
    azion_edge_application_cache_setting.this
  ]
  results = each.value.config
}

