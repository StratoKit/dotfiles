{
  description = "A Home Manager flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    let
      inherit (builtins) stringLength substring;

      local = import ./local_auto.nix;

      hasSuffix =
        # Suffix to check for
        suffix:
        # Input string
        content:
        let
          lenContent = stringLength content;
          lenSuffix = stringLength suffix;
        in
        lenContent >= lenSuffix &&
        substring (lenContent - lenSuffix) lenContent content == suffix;

      username = local.username;
      system = local.system;
      homeDirectory = if (hasSuffix "darwin" system) then "/Users/${username}" else "/home/${username}";
      extra = if (builtins.hasAttr "extra" local) then local.extra else null;
    in
    {
      defaultPackage = inputs.home-manager.defaultPackage;
      homeConfigurations = {
        ${username} = inputs.home-manager.lib.homeManagerConfiguration rec {
          inherit username homeDirectory system;
          pkgs = inputs.nixpkgs.outputs.legacyPackages.${system};
          configuration.imports = [
            ({ config, pkgs, lib, ... }: {
              nixpkgs.config = {
                allowUnfree = true;
                allowUnsupportedSystem = true;
              };
            })

            ./home.nix
          ];
        };
      };
    };
}
