#!/bin/sh

NAME="inference-service"
REGION="europe-west3"
PROJECT_ID=$(gcloud config get-value project)
DOCKER_IMG="gcr.io/$PROJECT_ID/$NAME"

gcloud builds submit --tag $DOCKER_IMG --timeout=500s

gcloud run deploy $NAME \
  --image $DOCKER_IMG \
  --platform managed \
  --region $REGION \
  --timeout 500s \
  --allow-unauthenticated

INFERENCE_ENDPOINT=$( \
  gcloud run services describe $NAME \
  --platform managed \
  --region $REGION \
  --format "value(status.url)" \
)

echo "Inference endpoint: $INFERENCE_ENDPOINT"
