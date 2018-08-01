#!/usr/bin/env bash

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
  osx) opam_update_on_osx ;;
  linux) opam_update_on_linux ;;
esac

opam install -y opam-devel
sudo cp /home/travis/.opam/4.05.0/lib/opam-devel/* /usr/local/bin
hash -r
opam upgrade -y || true
opam install . -y --deps
eval $(opam env)
make test
