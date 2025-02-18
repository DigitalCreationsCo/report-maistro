#!/bin/bash
set -e  # Exit immediately if a command fails

# Set project details
REGION=us-central1
PROJECT_ID=report-maistro

# Pull the latest Google Cloud SDK image
docker pull google/cloud-sdk:slim

# Create a temporary script file for execution inside the container
cat <<EOF > /tmp/update.sh
#!/bin/bash
set -e
echo "Authenticating service account..."
gcloud auth activate-service-account --key-file=/service-account.json
echo "Updating Cloud run service..."
gcloud run services update report-maistro --region $REGION --project $PROJECT_ID --image 'us-central1-docker.pkg.dev/report-maistro/report-maistro/report-maistro:latest'
echo "Deployment updated successfully!"
EOF

# Make the script executable
chmod +x /tmp/update.sh

# Run the script inside the Google Cloud SDK container
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME/.docker:/root/.docker:ro \
  -v $(pwd):/workspace \
  -v $(pwd)/service-account.json:/service-account.json:ro \
  -v /tmp/update.sh:/workspace/update.sh:ro \
  -w /workspace \
  google/cloud-sdk:slim \
  /bin/bash /workspace/update.sh

# Cleanup temporary script
rm -f /tmp/update.sh
