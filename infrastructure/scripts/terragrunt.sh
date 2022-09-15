#!/bin/bash

# usage: ./terragrunt.sh <COMMAND> [GLOBAL OPTIONS]

set -euo pipefail

# change to parent directory of this script so the context is correct
cd $(dirname $(dirname "$0"))

docker run --rm -e TF_IN_AUTOMATION -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_PROFILE \
        -v $(pwd):/app -w /app alpine/terragrunt:$(cat .terraform-version) terragrunt "$@"

echo "Done with $(basename $0)"
