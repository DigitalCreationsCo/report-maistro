provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone

  credentials="../service-account.json"
}

resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_network_name
  auto_create_subnetworks  = false  # Ensure manual subnet creation
}

resource "google_compute_subnetwork" "subnet" {
  name          = "${var.vpc_network_name}-subnet"
  ip_cidr_range = var.subnet_ip_range  # Reference the variable from tfvars
  network       = google_compute_network.vpc_network.id
  region        = var.region
}

resource "google_sql_database_instance" "postgresql_instance" {
  name             = var.postgresql_instance_name
  region           = var.region
  database_version = "POSTGRES_13"
  tier             = "db-f1-micro"

  settings {
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc_network.self_link
    }
  }

  deletion_protection = false  # Set to true for production
}

resource "google_sql_database" "postgresql_db" {
  name     = "reportmaistro"
  instance = google_sql_database_instance.postgresql_instance.name
}

resource "google_sql_user" "postgresql_user" {
  name     = var.postgresql_user
  instance = google_sql_database_instance.postgresql_instance.name
  password = var.postgresql_password
}

resource "google_redis_instance" "redis_instance" {
  name     = var.redis_instance_name
  region   = var.region
  location_id   = var.zone

  tier     = "STANDARD_HA"
  memory_size_gb = 1

  redis_version = "REDIS_6_X"
  authorized_network = google_compute_network.vpc_network.id
}

resource "google_cloud_run_service" "app" {
  name     = var.cloud_run_service_name
  location = var.region
  template {
    spec {
      containers {
        image = var.docker_image

        env {
          name  = "OPENAI_API_KEY"
          value = var.openai_api_key
        }
        env {
          name  = "GOOGLE_API_KEY"
          value = var.google_api_key
        }
        env {
          name  = "ANTHROPIC_API_KEY"
          value = var.anthropic_api_key
        }
        env {
          name  = "TAVILY_API_KEY"
          value = var.tavily_api_key
        }
        env {
          name  = "REDIS_URI"
          value = var.redis_uri
        }
        env {
          name  = "DATABASE_URI"
          value = var.database_uri
        }
        env {
          name  = "LANGSMITH_API_KEY"
          value = var.langsmith_api_key
        }
      }
    }
  }
}

resource "google_cloudbuild_trigger" "app_build_trigger" {
  name = "cloud-run-app-build"
  github {
    owner = "your-github-username"
    name  = "your-repo-name"
    push {
      branch = "main"
    }
  }
  
  build {
    steps {
      name = "gcr.io/cloud-builders/docker"
      args = [
        "build",
        "-t",
        "gcr.io/${var.project_id}/${var.docker_image}",
        "."
      ]
    }
    images = ["gcr.io/${var.project_id}/${var.docker_image}"]
  }
}

resource "google_compute_firewall" "allow_postgresql" {
  name    = "allow-postgresql"
  network = google_compute_network.vpc_network.self_link  # Referencing VPC name
  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }
  source_ranges = [var.subnet_ip_range]  # Reference the subnet range variable
}

resource "google_compute_firewall" "allow_redis" {
  name    = "allow-redis"
  network = google_compute_network.vpc_network.self_link  # Referencing VPC name
  allow {
    protocol = "tcp"
    ports    = ["6379"]
  }
  source_ranges = [var.subnet_ip_range] 
}
