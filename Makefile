SHELL = /bin/sh
DOCKER_IMAGE_TAG = besport-dotfiles

.SUFFIXES:
.PHONY: all docker-build

all: docker-build

docker-build:
	docker build --tag $(DOCKER_IMAGE_TAG) .
