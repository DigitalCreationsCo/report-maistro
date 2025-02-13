output "database_connection" {
  value = {
    host = google_sql_database_instance.postgresql_instance.private_ip_address
    port = 5432
    name = google_sql_database.postgresql_db.name
    user = google_sql_user.postgresql_user.name
  }
  sensitive = true
}

output "redis_connection" {
  value = {
    host = google_redis_instance.redis_instance.host
    port = google_redis_instance.redis_instance.port
  }
  sensitive = true
}