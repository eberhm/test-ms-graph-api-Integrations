#! /bin/sh

set -ex

TAG=$(npm pkg get version | sed 's/"//g')
DOCKER_VERSION="$ECR_PROJECT:$TAG"
ECR_URI="$ECR_HOST/$DOCKER_VERSION"

aws ecr get-login-password --region eu-central-1 --profile saml | docker login --username AWS --password-stdin $ECR_HOST

docker build -f ./Docker/Dockerfile -t $DOCKER_VERSION .

docker tag $DOCKER_VERSION $ECR_URI

docker push $ECR_URI