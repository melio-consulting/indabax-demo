#!/bin/bash

set -e 

while getopts n:r: opt
do 
  case "${opt}" in
      n) name="$OPTARG";;
      r) region="$OPTARG";;
      \?) echo "Invalid option -$OPTARG" >&2
      exit 1;;
  esac
done

PROJECT_ID=$(gcloud config get-value project)
DOCKER_IMG="gcr.io/$PROJECT_ID/$name"

# Build Docker image using Cloud Build
gcloud builds submit --tag $DOCKER_IMG --timeout=500s --suppress-logs

# Deploy built Docker image to Cloud Run
gcloud run deploy $name \
  --image $DOCKER_IMG \
  --platform managed \
  --region $region \
  --timeout 500s \
  --allow-unauthenticated

INFERENCE_ENDPOINT=$( 
  gcloud run services describe $name \
  --platform managed \
  --region $region \
  --format "value(status.url)" \
)

echo "Inference endpoint: $INFERENCE_ENDPOINT"
