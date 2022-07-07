#!@bash@/bin/bash

export PATH=$PATH:@git@/bin

function inform() {
	echo "$*" >&2
}

function die() {
	inform "$1"
	exit 1
}

system=$(nix-instantiate --eval --strict -E '(import <nixpkgs> {}).stdenv.hostPlatform.system' | sed 's/"//g')
if [[ "$system" == *darwin ]]; then
	configDir=~/Library/dotfiles
else
	configDir=~/.config/dotfiles
fi

if [ "$1" == --force ] || [ ! -r "$configDir/flake.nix" ]; then
	inform "Creating new dotfiles repository $configDir"

	mkdir -p "$configDir" || die "Could not create $configDir"
	cd "$configDir"

	username=$USER
	hostname=$(hostname)
	homeDirectory=~
	if [ -z "$username" ] || [ -z "$hostname" ] || [ -z "$system" ] || [ -z "$homeDirectory" ]; then
		die "could not determine parameters"
	fi

	[ ! -d .git ] && git init .
	[ ! -f .gitignore ] && echo settings.nix > .gitignore
	echo "{ username = \"$username\"; homeDirectory = \"$homeDirectory\"; hostname = \"$hostname\"; system = \"$system\"; }" > settings.nix
    cp @defaultFlake@ flake.nix
    cp @defaultReadme@ Readme.md
	chmod u+w flake.nix
	nix flake update .
	git add .
	git commit -a -m 'initial'
fi

# TODO inform when config flake is outdated

nix run "$configDir#update"
