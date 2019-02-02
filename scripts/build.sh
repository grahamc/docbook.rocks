#!/usr/bin/env bash

export USER=$(whoami)

mkdir /nix
curl https://nixos.org/nix/install | bash

nix-build ./scripts/build.nix --out-link ./result
