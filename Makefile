SHELL = /bin/sh
DOCKER_IMAGE_TAG = besport-dotfiles

.SUFFIXES:
.PHONY: all docker-build docker-debug-emacs-init

all: docker-build

docker-build:
	docker build --tag $(DOCKER_IMAGE_TAG) .

docker-debug-emacs-init: docker-build
	docker run --interactive --rm --tty $(DOCKER_IMAGE_TAG)	\
		emacs --debug-init
