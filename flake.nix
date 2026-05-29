{
  description = "Chinese Manual Pages (manpages-zh) Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      utils,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = rec {
          default = manpages-zh-cn;

          manpages-zh = pkgs.callPackage ./package.nix {
            withTW = true;
          };

          manpages-zh-minimal = pkgs.callPackage ./package.nix {
            with-TW = true;
            withColophon = false;
          };

          manpages-zh-cn = pkgs.callPackage ./package.nix { };

          manpages-zh-tw = pkgs.callPackage ./package.nix {
            withCN = false;
            withTW = true;
          };

          manpages-zh-cn-minimal = pkgs.callPackage ./package.nix {
            withCN = true;
            withColophon = false;
          };
          manpages-zh-tw-minimal = pkgs.callPackage ./package.nix {
            withCN = false;
            withTW = true;
            withColophon = false;
          };
        };
      }
    );
}
