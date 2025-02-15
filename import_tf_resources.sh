# Import VPC Network
terraform import google_compute_network.vpc_network report-maistro-network

# Import Subnet
terraform import google_compute_subnetwork.subnet projects/report-maistro/regions/us-central1/subnetworks/report-maistro-network-subnet

# Import PostgreSQL instance
terraform import google_sql_database_instance.postgresql_instance postgresql-instance

# Import PostgreSQL database
terraform import google_sql_database.postgresql_db projects/report-maistro/instances/postgresql-instance/databases/reportmaistro

# Import Redis instance
terraform import google_redis_instance.redis_instance projects/report-maistro/locations/us-central1-a/instances/redis-instance

# Import Cloud Run service
terraform import google_cloud_run_service.app locations/us-central1/namespaces/report-maistro/services/report-maistro-app

# Import Cloud Build trigger
terraform import google_cloudbuild_trigger.app_build_trigger projects/report-maistro/triggers/cloud-run-app-build

# Import firewall rules
terraform import google_compute_firewall.allow_postgresql allow-postgresql
terraform import google_compute_firewall.allow_redis allow-redis