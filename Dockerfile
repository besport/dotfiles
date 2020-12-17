FROM ubuntu
RUN apt-get update --yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes emacs opam
RUN adduser besport
USER besport
RUN opam init --auto-setup --disable-sandboxing --yes
RUN opam update --yes && opam install --yes caml-mode merlin ocamlformat tuareg
RUN eval $(opam env)
WORKDIR /home/besport
COPY --chown=besport . .
CMD ["bash"]
