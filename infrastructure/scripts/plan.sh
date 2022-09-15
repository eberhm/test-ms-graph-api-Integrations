#!/bin/bash

# usage: ./plan.sh <ENVIRONMENT>

set -euo pipefail

# change to parent directory of this script so the context is correct
cd $(dirname $(dirname "$0"))

# interpret first argument as environment to set working directory
terragrunt_environment=$1

terraform_lock=false

if [[ "$terragrunt_environment" == production ]]; then
  terraform_lock=true
fi

source scripts/terragrunt.sh plan -lock=$terraform_lock -out=/app/environments/$terragrunt_environment/.out/tfplan.binary \
        --terragrunt-working-dir=environments/$terragrunt_environment --terragrunt-source-update
