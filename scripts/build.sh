#!/usr/bin/env bash

curl https://nixos.org/nix/install | bash

nix-build ./scripts/build.nix --out-link ./result
