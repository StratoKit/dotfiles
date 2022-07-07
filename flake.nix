{
  description = "A Home Manager flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # our default nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, home-manager }: {
    inherit home-manager;
    makeDefaults = import ./home.nix;
  } //
  flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      thisHM = home-manager.packages.${system}.default;
      install = pkgs.substituteAll {
        src = ./install.sh;
        isExecutable = true;
        inherit (pkgs) bash git;
        defaultFlake = ./default-flake.nix;
        defaultReadme = ./default-readme.md;
      };
      update = pkgs.substituteAll {
        src = ./update.sh;
        isExecutable = true;
        inherit (pkgs) bash;
        homeManager = thisHM;
      };
    in
    {
      inherit pkgs;

      apps.default = {
        type = "app";
        program = "${install}";
      };
      apps.update = {
        type = "app";
        program = "${update}";
      };
    }
  );
}
