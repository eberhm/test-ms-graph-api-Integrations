#! /bin/sh

net=$(docker network ls -f name=development-network -q)

if [[ -z $net ]]; then
  @echo "Creating development network\n"
	docker network create development-network
fi