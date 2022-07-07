#!@bash@/bin/bash

function inform() {
	echo "$*" >&2
}

system=$(nix-instantiate --eval --strict -E '(import <nixpkgs> {}).stdenv.hostPlatform.system' | sed 's/"//g')
if [[ "$system" == *darwin ]]; then
	configDir=~/Library/dotfiles
else
	configDir=~/.config/dotfiles
fi

inform "Running home-manager switch"
@homeManager@/bin/home-manager --flake "$configDir" switch -b before-home-manager "$@"
