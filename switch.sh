#!/usr/bin/env bash
mydir=$(dirname "$0")
case $mydir in /*) :;; *) mydir="$PWD/$mydir";; esac
cd "$mydir"

function err() {
	echo "$*" >&2
}

function die() {
	err "$1"
	exit 1
}

function doSudo() {
	err "Executing as root: $*"
	sudo "$@"
}

if ! type -p nix >/dev/null; then
	err "Nix is not installed, installing..."
	sh <(curl -L https://nixos.org/nix/install) --daemon
	source ~/.nix-profile/etc/profile.d/nix.sh
	if ! type -p nix >/dev/null; then
		die "couldn't find nix"
	fi
fi

if ! grep -q flakes /etc/nix/nix.conf; then
	doSudo sh -c '(echo; echo "experimental-features = nix-command flakes") >> /etc/nix/nix.conf'
fi

username=$USER
hostname=$HOST
system=$(nix-instantiate --eval --strict -E '(import <nixpkgs> {}).stdenv.hostPlatform.system')

if [ -z "$username" ] || [ -z "$hostname" ] || [ -z "$system" ]; then
	die "could not determine parameters"
fi

echo "{ username = \"$username\"; hostname = \"$hostname\"; system = $system; }" > local_auto.nix

echo "Running home-manager switch"
nix run . -- --flake . switch -b backup"$@"
