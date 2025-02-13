#!/bin/bash
set -e  # Exit immediately if a command fails

# Set project details
REGION=us-central1
PROJECT_ID=report-maistro
TAG=${TAG:-latest}

# Pull the latest Google Cloud SDK image
docker pull google/cloud-sdk:slim

# Create a temporary script file for execution inside the container
cat <<EOF > /tmp/gcloud_script.sh
#!/bin/bash
set -e

echo "Authenticating service account..."
gcloud auth activate-service-account --key-file=/service-account.json

echo "Retrieving project number..."
PROJECT_NUMBER=\$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
echo "Using PROJECT_NUMBER=\$PROJECT_NUMBER"

# Ensure PROJECT_NUMBER is set correctly
if [ -z "\$PROJECT_NUMBER" ]; then
  echo "Error: PROJECT_NUMBER is not set correctly!"
  exit 1
fi

echo "Setting project configuration..."
gcloud config set project $PROJECT_ID

echo "Assigning IAM roles..."

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=serviceAccount:\${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
  --role=roles/run.admin

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=serviceAccount:\${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
  --role=roles/storage.objectUser

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member=serviceAccount:\${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
  --role=roles/artifactregistry.writer

gcloud iam service-accounts add-iam-policy-binding \${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
  --member=serviceAccount:\${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
  --role=roles/iam.serviceAccountUser \
  --project=$PROJECT_ID

echo "Creating Artifact Registry repository..."
gcloud artifacts repositories create report-maistro \
  --repository-format=docker \
  --location=$REGION \
  --project=$PROJECT_ID \
  --description="Report Maistro Langgraph App" || echo "Repository might already exist, continuing..."

echo "Listing repositories..."
gcloud artifacts repositories list --project=$PROJECT_ID

echo "Submitting Cloud Build..."
export TAG=$TAG REGION=$REGION
gcloud builds submit --region=\$REGION --config clouddeploy.yaml

echo "Deployment completed successfully!"
EOF

# Make the script executable
chmod +x /tmp/gcloud_script.sh

# Run the script inside the Google Cloud SDK container
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME/.docker:/root/.docker:ro \
  -v $(pwd):/workspace \
  -v $(pwd)/service-account.json:/service-account.json:ro \
  -v /tmp/gcloud_script.sh:/workspace/gcloud_script.sh:ro \
  -w /workspace \
  google/cloud-sdk:slim \
  /bin/bash /workspace/gcloud_script.sh

# Cleanup temporary script
rm -f /tmp/gcloud_script.sh
