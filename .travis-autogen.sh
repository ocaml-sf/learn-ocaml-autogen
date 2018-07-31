#!/usr/bin/env bash

. .travis-ocaml.sh

sudo add-apt-repository -y ppa:ansible/bubblewrap
sudo apt-get -y update
sudo apt-get install -y bubblewrap
opam install -y opam-devel
sudo cp /home/travis/.opam/4.05.0/lib/opam-devel/* /usr/local/bin
hash -r
opam upgrade -y || true
opam install . -y --deps
eval $(opam env)
make test
