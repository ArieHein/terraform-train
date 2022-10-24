terraform {
  required_version = "=1.3.3"
}

module "web_app" {
  source                  = "../../modules/web_app"
  app_project_prefix      = var.component_project_prefix
  app_project_location    = var.component_project_location
  app_environment_prefix  = var.component_environment_prefix
  app_location            = var.component_location
  app_resource_group      = var.component_resource_group
  app_instrumentation_key = module.application_insights.instrumentation_key
  app_plan_id             = module.service_plan.plan_id
  app_sql_server_name     = var.component_sql_server_name
  app_sql_database_name   = var.component_sql_database_name
  app_kv_id               = var.component_kv_id
  app_tags                = var.component_tags
}

module "service_plan" {
  source                  = "../../modules/service_plan"
  plan_project_prefix     = var.component_project_prefix
  plan_project_location   = var.component_project_location
  plan_environment_prefix = var.component_environment_prefix
  plan_location           = var.component_location
  plan_resource_group     = var.component_resource_group
  plan_os_name            = "windows"
  plan_sku_name           = var.component_sku_name
  plan_worker_count       = var.component_worker_count
  plan_tags               = var.component_tags
}

module "application_insights" {
  source                 = "../../modules/application_insights"
  ais_project_prefix     = var.component_project_prefix
  ais_project_location   = var.component_project_location
  ais_environment_prefix = var.component_environment_prefix
  ais_location           = var.component_location
  ais_resource_group     = var.component_resource_group
  ais_tags               = var.component_tags
}