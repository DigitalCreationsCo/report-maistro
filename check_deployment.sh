#!/bin/bash
set -e

cat <<EOF > /tmp/check_deployment.sh
#!/bin/bash
set -e
echo "Authenticating service account..."
gcloud auth activate-service-account --key-file=/service-account.json

echo "Checking deployment..."
gcloud run services describe report-maistro --project=report-maistro --region=us-central1 --format=json
EOF

chmod +x /tmp/check_deployment.sh

docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME/.docker:/root/.docker:ro \
  -v $(pwd):/workspace \
  -v $(pwd)/service-account.json:/service-account.json:ro \
  -v /tmp/check_deployment.sh:/workspace/check_deployment.sh:ro \
  -w /workspace \
  google/cloud-sdk:slim \
  /bin/bash /workspace/check_deployment.sh


# Cleanup temporary script
rm -f /tmp/check_deployment.sh
