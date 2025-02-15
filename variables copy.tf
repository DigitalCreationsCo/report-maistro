variable "project_id" {
  description = "The Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "The region to deploy resources in"
  type        = string
}

variable "zone" {
  description = "The zone to deploy resources in"
  type        = string
}

variable "vpc_network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "subnet_ip_range" {
  description = "The IP range for the VPC subnet"
  type        = string
}

variable "postgresql_instance_name" {
  description = "The name of the PostgreSQL Cloud SQL instance"
  type        = string
}

variable "redis_instance_name" {
  description = "The name of the Redis Cloud Memorystore instance"
  type        = string
}

variable "cloud_run_service_name" {
  description = "The name of the Cloud Run service"
  type        = string
}

variable "docker_image" {
  description = "The Docker image URL for the Cloud Run app"
  type        = string
}

variable "postgresql_user" {
  description = "The PostgreSQL user name"
  type        = string
}

variable "postgresql_password" {
  description = "The PostgreSQL user password"
  type        = string
}

variable "redis_uri" {
  description = "The URI of the Redis instance"
  type        = string
}

variable "database_uri" {
  description = "The URI of the PostgreSQL database"
  type        = string
}

variable "openai_api_key" {
  description = "The OpenAI API key"
  type        = string
}

variable "google_api_key" {
  description = "The Google API key"
  type        = string
}

variable "anthropic_api_key" {
  description = "The Anthropic API key"
  type        = string
}

variable "tavily_api_key" {
  description = "The Tavily API key"
  type        = string
}

variable "langsmith_api_key" {
  description = "The Langsmith API key"
  type        = string
}
