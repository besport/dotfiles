FROM ubuntu
RUN apt-get update --yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes emacs opam
RUN adduser besport
USER besport
RUN opam init --auto-setup --disable-sandboxing --yes
RUN opam update --yes && opam install --yes caml-mode ocaml-lsp-server \
    ocamlformat tuareg
RUN eval $(opam env)
WORKDIR /home/besport
COPY --chown=besport . .
RUN emacs --batch --load .emacs.d/lisp/util.el --quick \
	  --eval "(progn \
		    (util-init-package-archives) \
		    (package-refresh-contents))"
CMD ["bash"]
