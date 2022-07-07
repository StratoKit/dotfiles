# StratoKit dotfiles via home-manager

This manages our dotfiles and enables direnv.

## Installation

If you don't have Nix installed yet or you're not sure about it supporting flakes, run

```sh
NIX_EXTRA_CONF='experimental-features = nix-command flakes' sh <(curl -L https://nixos.org/nix/install) --daemon
```

Once it's installed, open a new terminal.

Add this repo to your flake registry by running:

```sh
nix registry add dotfiles github:StratoKit/dotfiles
```

Then to install or to update, just run it:

```nix
nix run dotfies
```

## Details

This will create a local dotfiles repo that stores your configuration and is editable.

On macOS, it is stored under `~/Library/dotfiles`, and on Linux, `~/.config/dotfiles`.

This allows you to override everything, including the version of nixpkgs that is used.
