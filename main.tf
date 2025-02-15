terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

module "python_app" {
  source = "./modules/gcp-python-app"

  project_id            = var.project_id
  region               = var.region
  zone                 = var.zone
  app_name             = var.app_name
  container_image      = var.container_image
  db_name              = var.db_name
  db_user              = var.db_user
  db_password          = var.db_password
  db_tier              = var.db_tier
  redis_memory_size    = var.redis_memory_size
  subnet_cidr          = var.subnet_cidr
  vpc_connector_cidr   = var.vpc_connector_cidr
  environment_variables = var.environment_variables
}