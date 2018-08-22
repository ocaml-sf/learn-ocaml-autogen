#!/usr/bin/env bash

# Inspired from https://github.com/ocaml-sf/learn-ocaml/.travis-learnocaml.sh

. .travis-ocaml.sh

install_bubblewrap_on_linux () {
  sudo add-apt-repository -y ppa:ansible/bubblewrap
  sudo apt-get -y update
  sudo apt-get install -y bubblewrap
}

install_bubblewrap_on_osx () {
  brew install ansible
}

case $TRAVIS_OS_NAME in
  linux) install_bubblewrap_on_linux; ROOT=home;;
  osx) install_bubblewrap_on_osx; ROOT=Users;;
esac

opam install -y opam-devel
sudo cp /$ROOT/travis/.opam/4.05.0/lib/opam-devel/* /usr/local/bin
hash -r
opam upgrade -y || true
opam install . -y --deps
eval $(opam env)
make test
