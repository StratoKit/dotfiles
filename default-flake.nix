{
  description = "StratoKit dotfiles flake, see https://github.com/StratoKit/dotfiles";

  inputs = {
    # You can choose a different flake here
    dotfiles.url = "github:StratoKit/dotfiles";

    # With this you can override nixpkgs or similarly home-manager
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # dotfiles.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs:
    let
      # The auto-generated settings
      settings = import ./settings.nix;
      inherit (settings) username homeDirectory hostname system configDirectory;
      # The inputs provided by the dotfiles repo
      inherit (inputs.dotfiles) nixpkgs home-manager;

      pkgs = inputs.dotfiles.pkgs.${system};
    in
    {
      # The commands you can run
      apps.${system} = {
        # Just use the apps from the main repo
        inherit (inputs.dotfiles.apps.${system}) default update;
      };

      # The home-manager configuration
      homeConfigurations = {
        ${username} = home-manager.lib.homeManagerConfiguration rec {
          inherit pkgs;
          modules = [
            # This provides the default StratoKit configuration
            (inputs.dotfiles.makeDefaults settings)

            # Here you can add your own extra module files to import
            # ./home.nix

            # or specify them inline
            # ({ config, pkgs, lib, ... }: {
            #   nixpkgs.config = {
            #     # allowUnfree = true;
            #     # allowUnsupportedSystem = true;
            #   };
            # })

            # Update this only when you know what you are doing
            { home.stateVersion = "22.05"; }
          ];
        };
      };
    };
}
