SHELL = /bin/sh
DOCKER_IMAGE_TAG = besport-dotfiles

.SUFFIXES:
.PHONY: all docker-build docker-debug-emacs-init install	\
	install-bash-config install-emacs

all: docker-build

install: install-bash-config install-emacs

docker-build:
	docker build --tag $(DOCKER_IMAGE_TAG) .

docker-debug-emacs-init: docker-build
	docker run --interactive --rm --tty $(DOCKER_IMAGE_TAG)	\
		bash -ci emacs --debug-init

install-bash-config:
	grep -q "if \[ -f ~/.besport_bashrc.bash ]; then" ~/.bashrc	\
	|| printf "\nif %s; then\n    %s\nfi\n"				\
		"[ -f ~/.besport_bashrc.bash ]"				\
		". ~/.besport_bashrc.bash"				\
		>> ~/.bashrc

install-emacs:
	emacs --batch --load .emacs.d/lisp/util.el --quick	\
	  --eval "(progn					\
		    (util-init-package-archives)		\
		    (package-refresh-contents))"
