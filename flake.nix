{
  description = "Suckless Terminal";

  inputs.nixpkgs.url = "nixpkgs/nixos-24.05";

  outputs =
    { self, nixpkgs }:
    let

      # to work with older version of flakes
      lastModifiedDate = self.lastModifiedDate or self.lastModified or "19700101";

      # Generate a user-friendly version number.
      version = "0.8.4";

      # System types to support.
      supportedSystems = [ "x86_64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Nixpkgs instantiated for supported system types.
      nixpkgsFor = forAllSystems (
        system:
        import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        }
      );
    in
    {

      # A Nixpkgs overlay.
      overlay = final: prev: {

        st =
          with final;
          stdenv.mkDerivation rec {
            pname = "st";
            inherit version;

            src = ./.;

            nativeBuildInputs = [
              nixpkgsFor.${system}.pkg-config
              nixpkgsFor.${system}.harfbuzz
              nixpkgsFor.${system}.freetype
              nixpkgsFor.${system}.fontconfig
              nixpkgsFor.${system}.xorg.libX11.dev
              nixpkgsFor.${system}.xorg.libXft
              autoreconfHook
            ];
          };

      };

      # Provide some binary packages for selected system types.
      packages = forAllSystems (system: {
        inherit (nixpkgsFor.${system}) st;
      });

      # The default package for 'nix build'. This makes sense if the
      # flake provides only one package or there is a clear "main"
      # package.
      defaultPackage = forAllSystems (system: self.packages.${system}.st);

      # A NixOS module, if applicable (e.g. if the package provides a system service).
      nixosModules.st =
        { pkgs, ... }:
        {
          nixpkgs.overlays = [ self.overlay ];
          environment.systemPackages = [ pkgs.st ];
        };
    };
}
