#!/bin/bash

# REALLY DANGEROUS!!!
# you need to have installed jq and aws_cli
# usage: TF_ENV=preview AWS_REGION=eu-central-1 ./scripts/deleteSecrets.sh
# 

set -euo pipefail

read -p "Are you sure you want to remove secrets? this will be a permanent action! [yes/no]" 
if [ "$REPLY" != "yes" ]; then
   exit
fi

# change to parent directory of this script so the context is correct
cd $(dirname $(dirname "$0"))/environments/${TF_ENV}/secrets

# save secrets arns for later destroy
SECRET_ARNS=$(AWS_PROFILE=saml terragrunt output -json secrets_arn )

AWS_PROFILE=saml terragrunt destroy -auto-approve

#permanently destroy secrets one by one
echo "$SECRET_ARNS" | jq -r '.[]' | while read -r secret_arn; do 
    echo "deleting $secret_arn...";

    aws --profile saml secretsmanager delete-secret --secret-id $secret_arn --force-delete-without-recovery --region $AWS_REGION --no-cli-pager --profile saml
    echo "done"
done


