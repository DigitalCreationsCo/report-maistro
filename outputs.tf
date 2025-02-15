output "database_connection" {
  value = {
    host = google_sql_database_instance.postgresql_instance.private_ip_address
    port = 5432
    name = google_sql_database.postgresql_db.name
    user = google_sql_user.postgresql_user.name
  }
}

output "redis_connection" {
  value = {
    host = google_redis_instance.redis_instance.host
    port = google_redis_instance.redis_instance.port
  }
}

# Cloud Run Service outputs
output "cloud_run_service_url" {
  description = "The URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.app.status[0].url
}

output "cloud_run_service_name" {
  description = "The name of the Cloud Run service"
  value       = google_cloud_run_service.app.name
}

# PostgreSQL outputs
output "postgresql_instance_name" {
  description = "The name of the PostgreSQL instance"
  value       = google_sql_database_instance.postgresql_instance.name
}

output "postgresql_private_ip" {
  description = "The private IP of the PostgreSQL instance"
  value       = google_sql_database_instance.postgresql_instance.private_ip_address
}

output "postgresql_connection_name" {
  description = "The connection name of the PostgreSQL instance"
  value       = google_sql_database_instance.postgresql_instance.connection_name
}

# Redis outputs
output "redis_instance_name" {
  description = "The name of the Redis instance"
  value       = google_redis_instance.redis_instance.name
}

output "redis_host" {
  description = "The hostname of the Redis instance"
  value       = google_redis_instance.redis_instance.host
}

# VPC Network outputs
output "vpc_network_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.vpc_network.id
}

output "vpc_subnet_id" {
  description = "The ID of the VPC subnet"
  value       = google_compute_subnetwork.subnet.id
}

# Container Registry/Artifact Registry outputs
output "docker_repository_url" {
  description = "The URL of the Docker repository"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/report-maistro"
}

# Cloud Build Trigger outputs
output "build_trigger_id" {
  description = "The ID of the Cloud Build trigger"
  value       = google_cloudbuild_trigger.app_build_trigger.trigger_id
}