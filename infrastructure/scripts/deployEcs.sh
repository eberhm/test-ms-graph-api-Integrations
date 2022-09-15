#!/bin/bash

# usage 
# sh infrastructure/scripts/deployEcs.sh -r REGION -e ENVIRONMENT -a APP_NAME -t -m true (if you want to generate migrate image) TAG (optional) 

# default tag
tag=latest
migrate=false

timestamp=$(date +%s)

if [ $# -le 2 ]
  then
    echo "Missing argmuments"
    exit 1
fi
while getopts r:a:e:m:t flag
do
    case "${flag}" in
        r) region=${OPTARG};;
        a) app=${OPTARG};;
        e) env=${OPTARG};;
        t) tag=${OPTARG};;
        m) migrate=${OPTARG};;
    esac
done

echo "region: $region";
echo "app: $app";
echo "env: $env";
echo "tag: $tag";
echo "migrate: $migrate";

repository=$app-$env
dockerFilePath=./Docker/Dockerfile  

if [ $migrate == "true" ]; then
    repository=$app-$env-dbmigrator
    dockerFilePath=./Docker/dbMigrator/Dockerfile  
fi

echo "repository: $repository";
echo "dockerFilePath: $dockerFilePath";

read -p "Are you sure you want to continue? [yes/no]" 
if [ "$REPLY" != "yes" ]; then
   exit
fi

account_id=$(aws sts get-caller-identity --query "Account" --output text --profile saml)

aws ecr get-login-password --region $region --profile saml | docker login --username AWS --password-stdin $account_id.dkr.ecr.$region.amazonaws.com

docker build -t $repository:$USER-$timestamp . -f $dockerFilePath  

docker tag $repository:$USER-$timestamp $account_id.dkr.ecr.$region.amazonaws.com/$repository:$USER-$timestamp

docker push $account_id.dkr.ecr.$region.amazonaws.com/$repository:$USER-$timestamp

#Retag as tag param
MANIFEST=$(aws --region $region --profile saml  ecr batch-get-image --repository-name $repository --image-ids imageTag=$USER-$timestamp --output json | jq --raw-output --join-output '.images[0].imageManifest')
# avoiding the noisy output which hangs execution until user pushes some key
out=$(aws --region $region --profile saml ecr put-image --repository-name $repository --image-tag $tag --image-manifest "$MANIFEST" )


# HOW TO EXECUTE A MIGRATION FROM AWS CLI
#
# 1. get the state machine arn for the state machine
# aws --profile saml --region eu-central-1 stepfunctions start-execution --state-machine-arn STATE_MACHINE_ARN --query "executionArn"
#
# 2. the previous step returns the execution arn so you can query for the status
# aws --profile saml --region eu-central-1 stepfunctions describe-execution --execution-arn EXECUTION_ARN_OF_STATE_MACHINE --query "status"