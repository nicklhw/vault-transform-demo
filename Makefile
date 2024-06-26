.DEFAULT_GOAL := all
.PHONY: clean up-detach init show-members ui token

export VAULT_ADDR := http://localhost:8200

all: build-api build-ui clean up-detach init

up-detach:
	cd docker-compose \
	  && docker-compose --profile backend up --detach

init:
	cd docker-compose/scripts \
	  && ./init.sh

clean:
	cd docker-compose \
	&& docker-compose --profile frontend down --volumes --remove-orphans \
	&& docker-compose down --volumes --remove-orphans \
	&& rm -f ./scripts/vault.json

show-members:
	vault operator raft list-peers

logs:
	cd docker-compose \
    && docker-compose logs -f

ui:
	open http://localhost:7071

build-api:
	cd demo-api \
	&& ./mvnw clean package

build-ui:
	cd demo-ui \
	&& ./mvnw clean package

run-api:
	cd demo-api \
	&& ./mvnw spring-boot:run

run-ui:
	cd demo-ui \
	&& ./mvnw spring-boot:run

build-docker-api:
	docker build -t nicklhw/transform-demo-api -f demo-api/Dockerfile ./demo-api

build-docker-ui:
	docker build -t nicklhw/transform-demo-ui -f demo-ui/Dockerfile ./demo-ui