#!/bin/bash

# usage: ./apply.sh <ENVIRONMENT>

set -euo pipefail

# change to parent directory of this script so the context is correct
cd $(dirname $(dirname "$0"))

# interpret first argument as environment to set working directory
terragrunt_environment=$1

source scripts/terragrunt.sh apply -auto-approve /app/environments/$terragrunt_environment/.out/tfplan.binary \
        --terragrunt-working-dir=environments/$terragrunt_environment
