provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone

  credentials = "./service-account.json"
}

## VPC Network
resource "google_compute_network" "vpc" {
  name                    = "${var.app_name}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.app_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  network       = google_compute_network.vpc.id
  region        = var.region
}

# Private Service Access
resource "google_compute_global_address" "private_ip_address" {
  name          = "${var.app_name}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

# Enable private services access API
resource "google_project_service" "servicenetworking" {
  service = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

# Enable Redis API
resource "google_project_service" "redis" {
  service = "redis.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud SQL API
resource "google_project_service" "sql" {
  service = "sql-component.googleapis.com"
  disable_on_destroy = false
}

# PostgreSQL Instance
resource "google_sql_database_instance" "postgresql" {
  name             = "${var.app_name}-postgres"
  database_version = "POSTGRES_14"
  region           = var.region
  
  depends_on = [
    google_service_networking_connection.private_vpc_connection,
    google_project_service.sql
  ]

  settings {
    tier = var.db_tier
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.id
    }
  }
  deletion_protection = false
}

resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.postgresql.name
}

resource "google_sql_user" "db_user" {
  name     = var.db_user
  instance = google_sql_database_instance.postgresql.name
  password = var.db_password
}

# Redis Instance
resource "google_redis_instance" "cache" {
  name           = "${var.app_name}-redis"
  tier           = "BASIC"
  memory_size_gb = var.redis_memory_size
  region         = var.region
  location_id    = var.zone
  
  depends_on = [
    google_service_networking_connection.private_vpc_connection,
    google_project_service.redis
  ]

  authorized_network = google_compute_network.vpc.id
  connect_mode      = "PRIVATE_SERVICE_ACCESS"

  redis_version = "REDIS_6_X"
  display_name  = "${var.app_name} Redis Cache"
}


# Cloud Run Service
resource "google_cloud_run_service" "app" {
  name     = var.app_name
  location = var.region

  template {
    spec {
      containers {
        image = var.container_image
        
        startup_probe {
          initial_delay_seconds = 30
          timeout_seconds = 10
          period_seconds = 15
          failure_threshold = 3
          tcp_socket {
            port = 8000
          }
        }

        liveness_probe {
          initial_delay_seconds = 50
          timeout_seconds = 10
          period_seconds = 15
          failure_threshold = 3
          http_get {
            port = 8000
          }
        }

        ports  {
          container_port = 8000
        }

        dynamic "env" {
          for_each = var.environment_variables
          content {
            name  = env.key
            value = env.value
          }
        }

        env {
          name  = "DATABASE_URI"
          value = "postgresql://${var.db_user}:${var.db_password}@${google_sql_database_instance.postgresql.private_ip_address}:5432/${var.db_name}?sslmode=disable"
        }

        env {
          name  = "REDIS_URI"
          value = "redis://${google_redis_instance.cache.host}:${google_redis_instance.cache.port}"
        }
      }
    }

    metadata {
      annotations = {
        "run.googleapis.com/vpc-access-connector" = google_vpc_access_connector.connector.name
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.postgresql.connection_name
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# VPC Access Connector
resource "google_vpc_access_connector" "connector" {
  name          = "vpcconnector"
  ip_cidr_range = var.vpc_connector_cidr
  network       = google_compute_network.vpc.name
  region        = var.region
}

# IAM
resource "google_cloud_run_service_iam_member" "public" {
  location = google_cloud_run_service.app.location
  project  = var.project_id
  service  = google_cloud_run_service.app.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Firewall Rules
resource "google_compute_firewall" "allow_internal" {
  name    = "${var.app_name}-allow-internal"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["5432", "6379", "8000"]
  }

  source_ranges = [var.subnet_cidr, var.vpc_connector_cidr]
}