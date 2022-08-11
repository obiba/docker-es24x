#
# Docker helper
#

no_cache=false

docker_compose_file=docker-compose.yml

up:
	docker-compose -f $(docker_compose_file) up -d --remove-orphans

down:
	docker-compose -f $(docker_compose_file) down

stop:
	docker-compose -f $(docker_compose_file) stop

start:
	docker-compose -f $(docker_compose_file) start

restart:
	docker-compose -f $(docker_compose_file) restart

pull:
	docker-compose -f $(docker_compose_file) pull

logs:
	docker-compose -f $(docker_compose_file) logs -f

build:
	docker-compose -f $(docker_compose_file) build --no-cache

# Build Docker image
build-image:
	docker build --no-cache=$(no_cache) -t="obiba/es246:latest" .

push-image:
	 docker image push obiba/es246:latest

clean:
	rm -rf target

