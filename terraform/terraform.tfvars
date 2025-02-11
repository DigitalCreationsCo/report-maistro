project_id              = "report-maistro"
region                  = "us-central1"
zone                    = "us-central1-a"
vpc_network_name        = "report-maistro-network"
subnet_ip_range         = "10.0.0.0/24"

postgresql_instance_name = "postgresql-instance"
redis_instance_name      = "redis-instance"
cloud_run_service_name   = "report-maistro-app"

docker_image             = "gcr.io/report-maistro/report-maistro"

postgresql_user          = "postgresql"
postgresql_password      = "postgresql"

redis_uri                = "redis://<redis-private-ip>:6379"
database_uri             = "postgresql://<postgresql-private-ip>:5432/postgresql"
openai_api_key           = "sk-xxx"
google_api_key           = "your-api-key"
anthropic_api_key        = "sk-xxx"
tavily_api_key           = "xxx"
langsmith_api_key        = "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"
