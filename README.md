# Configuration files

This repository is organized in such a way that it can be directly used
as a home directory.

## Installation

For external dependencies, please refer to [Dockerfile](Dockerfile).  If
you want to use this repository as is as your home directory, you can
run the following commands in a terminal:

```shell
cd ~
git init
git remote add origin git@github.com:besport/dotfiles.git
git fetch origin
git checkout master
make install # or `make install-<component>` to install <component> individually
```

## Emacs

The provided configuration tries to use as much as possible built-in
Emacs packages.
