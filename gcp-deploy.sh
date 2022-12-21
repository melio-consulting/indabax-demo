#!/bin/sh

NAME="$1"
REGION="europe-west3"
PROJECT_ID=$(gcloud config get-value project)
DOCKER_IMG="gcr.io/$PROJECT_ID/$NAME"

# Check whoami
echo $(gcloud config list account --format "value(core.account)")

# Build Docker image using Cloud Build
gcloud builds submit --tag $DOCKER_IMG --timeout=500s

# Deploy built Docker image to Cloud Run
gcloud run deploy $NAME \
  --image $DOCKER_IMG \
  --platform managed \
  --region $REGION \
  --timeout 500s \
  --allow-unauthenticated

INFERENCE_ENDPOINT=$( 
  gcloud run services describe $NAME \
  --platform managed \
  --region $REGION \
  --format "value(status.url)" \
)

echo "Inference endpoint: $INFERENCE_ENDPOINT"
