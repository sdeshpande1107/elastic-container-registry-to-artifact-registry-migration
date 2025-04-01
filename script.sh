#!/bin/bash

# Variables
REGION="aws-region"                     # Example: ap-south-1
REGISTRY_ID="aws-account-id"            # Example: 8*****93***9
TARGET_REGISTRY="gcp-registry"          # Example: asia-south1-docker.pkg.dev
TARGET_PROJECT="gcp-project"            # Example: xyz-project
TARGET_REPO="gcp-repo"                  # Example: xyz-repo

# AWS ECR Login
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REGISTRY_ID.dkr.ecr.$REGION.amazonaws.com

# Google Artifact Registry Login
gcloud auth configure-docker $TARGET_REGISTRY

# Get all repository names from AWS ECR
repositories=$(aws ecr describe-repositories --region $REGION --query 'repositories[*].repositoryName' --output text)

# Loop through each repository
for repo in $repositories; do
    echo "Processing repository: $repo"

    # Get all images in the repository
    images=$(aws ecr describe-images --region $REGION --repository-name $repo --query 'imageDetails[*].imageTags[*]' --output text)

    # Check if images exist
    if [ -z "$images" ]; then
        echo "  No images found in repository $repo."
        continue
    fi

    # Loop through each image tag
    for tag in $images; do
        echo "  Processing image tag: $tag"

        # AWS ECR Image
        ecr_image="$REGISTRY_ID.dkr.ecr.$REGION.amazonaws.com/$repo:$tag"
        
        # Pull the image from ECR
        echo "    Pulling image from ECR: $ecr_image"
        docker pull $ecr_image

        # Tag the image for Google Artifact Registry
        artifact_image="$TARGET_REGISTRY/$TARGET_PROJECT/$TARGET_REPO/$repo:$tag"
        echo "    Tagging image for GCP: $artifact_image"
        docker tag $ecr_image $artifact_image

        # Push the image to Google Artifact Registry
        echo "    Pushing image to GCP: $artifact_image"
        docker push $artifact_image

        # Check if the push was successful
        if [ $? -eq 0 ]; then
            echo "    Image pushed successfully!"

            # Remove the local image (both ECR and GCP versions)
            echo "    Removing local images: $ecr_image and $artifact_image"
            docker rmi -f $ecr_image
            docker rmi -f $artifact_image
            echo "    Local images removed successfully!"
        else
            echo "    Failed to push image to GCP. Skipping deletion and moving to next image."
        fi
    done
done

echo "Script completed successfully!"
