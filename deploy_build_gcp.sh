#!/bin/bash
set -e  # Exit immediately if a command fails

REGION=us-central1
PROJECT_ID=report-maistro
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format='value(projectNumber)')
TAG=${TAG:-latest}

docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME/.docker:/root/.docker:ro \
  -v $(pwd):/workspace \
  -v $(pwd)/service-account.json:/service-account.json:ro \
  -w /workspace \
  google/cloud-sdk:slim \
  bash -c "\
    gcloud auth activate-service-account --key-file=/service-account.json && \
    
    gcloud projects add-iam-policy-binding $PROJECT_ID \
      --member=serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
      --role=roles/run.admin && \

    gcloud projects add-iam-policy-binding $PROJECT_ID \
      --member=serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
      --role='roles/storage.objectUser' && \

    gcloud iam service-accounts add-iam-policy-binding ${PROJECT_NUMBER}-compute@developer.gserviceaccount.com \
      --role='roles/iam.serviceAccountUser' \
      --project=$PROJECT_ID && \

    export TAG=$TAG REGION=$REGION && \
    gcloud builds submit --region=$REGION --config clouddeploy.yaml"
