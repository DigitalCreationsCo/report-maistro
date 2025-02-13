# 1. Apply Terraform to create database and Redis
terraform init
terraform apply

# 2. Get the connection details and create a config file
terraform output -json > config.json

# 3. Update your Cloud Build configuration with the secrets
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME/.docker:/root/.docker \
  -v $(pwd):/workspace \
  -v $(pwd)/service-account.json:/service-account.json:ro \
  -w /workspace \
  google/cloud-sdk:slim \
  bash -c "
    gcloud builds submit --config=clouddeploy.yaml \
    --substitutions=\
    _DB_HOST='$(terraform output -raw database_connection.host)',\
    _DB_USER='$(terraform output -raw database_connection.user)',\
    _DB_PASSWORD='$(terraform output -raw database_connection.password)',\
    _REDIS_HOST='$(terraform output -raw redis_connection.host)'"