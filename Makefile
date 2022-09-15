COLOR_NC := \033[0m
COLOR_WHITE := \033[1;37m
COLOR_BLACK := \033[0;30m
COLOR_BLUE := \033[0;34m
COLOR_LIGHT_BLUE := \033[1;34m
COLOR_GREEN := \033[0;32m
COLOR_LIGHT_GREEN := \033[1;32m
COLOR_CYAN := \033[0;36m
COLOR_LIGHT_CYAN := \033[1;36m
COLOR_RED := \033[0;31m
COLOR_LIGHT_RED := \033[1;31m
COLOR_PURPLE := \033[0;35m
COLOR_LIGHT_PURPLE := \033[1;35m
COLOR_BROWN := \033[0;33m
COLOR_YELLOW := \033[1;33m
COLOR_GRAY := \033[0;30m
COLOR_LIGHT_GRAY := \033[0;37m

include .env
export $(shell sed 's/=.*//' .env)

help: ## This help dialog.
	@echo "\n$(COLOR_GREEN)Environment configuration:$(COLOR_NC)\n"
	@echo "$(COLOR_BROWN)NODE_ENV $(COLOR_PURPLE)-> $(COLOR_LIGHT_GRAY)$(NODE_ENV)$(COLOR_NC)\n"	
	@IFS=$$'\n' ; \
    help_lines=(`fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//'`); \
    for help_line in $${help_lines[@]}; do \
        IFS=$$'#' ; \
        help_split=($$help_line) ; \
        help_command=`echo $${help_split[0]} | sed -e 's/^ *//' -e 's/ *$$//'` ; \
        help_info=`echo $${help_split[2]}` ; \
        printf "%-30s %s\n" $$help_command $$help_info ; \
    done
.PHONY: help

install: ## Installs all dependencies (docker for mac should be preinstalled)
	make create-docker-network
	make build
.PHONY: install

uninstall: ## Uninstalls dev environment
	docker-compose down -v
	docker-compose rm -s -v -f
.PHONY: uninstall

build: ## Builds the docker image
	TARGET=$(NODE_ENV) docker-compose --profile dev up -d --build
.PHONY: build

start: ## Starts the application, you can pass a CMD to run a yarn command ex:  make start CMD=start:debug will run yarn start:debug
	TARGET=$(NODE_ENV) PORT=$(PORT) CMD=${CMD} docker-compose --profile dev up -d
.PHONY: start

stop: ## Stops the application
	docker-compose --profile dev stop
.PHONY: stop

restart: ## Restarts the application
restart: stop start
.PHONY: restart

status: ## Status for the services (alias to docker-compose ps)
	docker-compose ps
.PHONY: status

shell: ## Initializes a shell
	docker-compose run --rm app sh
.PHONY: shell

test: ## Run tests for the file passed as parameter or the entire suite if none passed.
	docker-compose run --rm app yarn test
.PHONY: test

push-image-ecr: ## Run script to push the current image to ECR
	sh Docker/push_image_ecr.sh
.PHONY: push-image-ecr


## -------
## Only start services
## -------

start-services: ## Starts the local development services
	docker-compose --profile services up -d
.PHONY: start-services

stop-services: ## Stops the local development services
	docker-compose --profile services stop
.PHONY: stop-services

## -------
## Utils
## -------

create-docker-network: ## Creates the docker network
	sh Docker/set_network.sh
.PHONY: create-docker-network

db-migrate: ## Run migrations
	docker-compose run --rm app yarn migrate
.PHONY: db-migrate

create-db-migration: ## create migrations
	docker-compose run --rm app yarn migrate:dev --name $(NAME)
.PHONY: db-migrate