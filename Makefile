.DEFAULT_GOAL := all
.PHONY: clean up-detach init show-members ui token

export VAULT_ADDR := http://localhost:8200

all: clean up-detach init

up-detach:
	cd docker-compose \
	  && docker-compose up --detach --remove-orphans

init:
	cd docker-compose/scripts \
	  && ./init.sh

clean:
	cd docker-compose \
	&& docker-compose down --volumes \
	&& rm -f ./scripts/vault.json

show-members:
	vault operator raft list-peers

logs:
	cd docker-compose \
    && docker-compose logs -f

ui:
	open http://localhost:8080

build-api:
	cd demo-api \
	&& ./mvnw clean package

run-api:
	cd demo-api \
	&& java -jar target/transformdemo-0.0.1-SNAPSHOT.jar

build-docker-api:
	docker build -t nicklhw/transform-demo-api -f demo-api/Dockerfile ./demo-api