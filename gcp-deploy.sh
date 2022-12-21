#!/bin/sh

NAME="$1"
REGION="europe-west3"
PROJECT_ID=$(gcloud config get-value project)
DOCKER_IMG="gcr.io/$PROJECT_ID/$NAME"

gcloud config 

# Check whoami
echo "1"
echo $(gcloud config list account)
echo "2"
echo $(gcloud auth list)
echo "3"
echo $(gcloud config list)
echo "4"

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
