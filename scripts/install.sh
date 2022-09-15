#!/bin/bash

function download() {
  git clone --depth=1 git@github.com:onlyfyio/ecs-rds-nest-tf-template.git
  rm -Rf ecs-rds-nest-tf-template/.git
}


function customize() {
  LC_ALL=C find . -not -path '*/scripts/*' -type f -name '*.*' -exec sed -i '' s/sourcing/$1/g {} +
  LC_ALL=C find . -not -path '*/scripts/*' -type f -name '*.*' -exec sed -i '' s/sourcing-proxy/$1/g {} +
}

echo "Customize service name"
read -p "Name: " service_name

echo
while true; do
    read -p "You are about to create a new service called: $service_name, want to proceed? (y/n) " yn
    case $yn in
        [Yy]* ) download; customize $service_name; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y o n";;
    esac
done

mv ecs-rds-nest-tf-template ../$service_name

echo "Done! you can now cd into ../$service_name and delete this template!" 


