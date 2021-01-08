SHELL = /bin/sh
DOCKER_IMAGE_TAG = besport-dotfiles

.SUFFIXES:
.PHONY: all docker-build docker-debug-emacs-init install install-bash-config

all: docker-build

install: install-bash-config

docker-build:
	docker build --tag $(DOCKER_IMAGE_TAG) .

docker-debug-emacs-init: docker-build
	docker run --interactive --rm --tty $(DOCKER_IMAGE_TAG)	\
		emacs --debug-init

install-bash-config:
	grep -q "if \[ -f ~/.besport_bashrc.bash ]; then" ~/.bashrc	\
	|| printf "\nif %s; then\n    %s\nfi\n"				\
		"[ -f ~/.besport_bashrc.bash ]"				\
		". ~/.besport_bashrc.bash"				\
		>> ~/.bashrc
