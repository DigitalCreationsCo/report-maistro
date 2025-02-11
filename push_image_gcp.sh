#!/bin/bash
set -e  # Exit immediately if a command fails

REGION=us-central1
PROJECT_ID=report-maistro
TAG=${TAG:-latest}

# Get the project number (store it once to avoid redundant API calls)
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')

# Pull the Google Cloud SDK image
docker pull google/cloud-sdk:slim

# Run the Google Cloud SDK container and execute commands
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME/.docker:/root/.docker \
  -v $(pwd):/workspace \
  -v $(pwd)/service-account.json:/service-account.json:ro \
  -w /workspace \
  google/cloud-sdk:slim \
  bash -c "\
    gcloud auth activate-service-account --key-file=/service-account.json && \

    gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --role='roles/storage.objectUser' && \

    gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member=serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --role='roles/artifactregistry.writer' && \

    gcloud iam service-accounts add-iam-policy-binding $PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --member=serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com \
    --role='roles/iam.serviceAccountUser' \
    --project=$PROJECT_ID && \

    gcloud artifacts repositories create report-maistro --repository-format=docker \
    --project=$PROJECT_ID --location=$REGION \
    --description='Report Maistro Langgraph App' && \

    gcloud artifacts repositories list && \
    
    gcloud builds submit --region=$REGION \
    --tag ${REGION}-docker.pkg.dev/${PROJECT_ID}/report-maistro/report-maistro:${TAG}"
