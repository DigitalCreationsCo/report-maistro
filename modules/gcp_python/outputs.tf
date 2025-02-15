output "cloud_run_url" {
  description = "URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.app.status[0].url
}

output "database_connection" {
  description = "Database connection information"
  sensitive   = true
  value = {
    host     = google_sql_database_instance.postgresql.private_ip_address
    port     = 5432
    database = var.db_name
    username = var.db_user
    password = var.db_password
  }
}

output "redis_connection" {
  description = "Redis connection information"
  value = {
    host = google_redis_instance.cache.host
    port = google_redis_instance.cache.port
  }
}

output "vpc_network" {
  description = "VPC Network details"
  value = {
    name = google_compute_network.vpc.name
    id   = google_compute_network.vpc.id
  }
}