{
  description = "My operating system";

  inputs = { 
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
  };

  outputs = { self, nixpkgs }: 
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
        inherit system;

        config = {
            allowunfree = true;
        };
    };
  in
  {
    nixosConfigurations = {
      nix_config = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit system; };
        
        modules = [
          ./nixos/configuration.nix
        ];
      };
    };

  };
}
