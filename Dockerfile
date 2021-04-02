FROM ubuntu
RUN apt-get update --yes && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes emacs opam
RUN adduser besport
USER besport
RUN opam init --auto-setup --disable-sandboxing --yes
RUN opam update --yes && opam install --yes caml-mode ocaml-lsp-server \
    ocamlformat tuareg
WORKDIR /home/besport
COPY --chown=besport . .
RUN make install
CMD ["bash"]
