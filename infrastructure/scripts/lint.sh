#!/bin/bash

# usage: ./lint.sh

set -euo pipefail

# change to parent directory of this script so the context is correct
cd $(dirname $(dirname "$0"))

source scripts/terraform.sh fmt -check -recursive -diff terraform/
