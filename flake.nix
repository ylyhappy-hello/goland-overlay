{
  description = "my project description";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:

    let
      overlay =
      let version = "2022.3.4";
      in
        final: prev: {
          jetbrains-goland-ultimate-d = prev.jetbrains.goland.overrideAttrs (finalAttrs: {
            src = prev.fetchurl {
              url = "https://download.jetbrains.com/go/goland-${version}.tar.gz";
              sha256 = "sha256-+P+WM2xBarVqvqA4Gcs2N6HUa4CojoVE8enph0a3gaw=";
            };  
            installPhase = finalAttrs.installPhase + ''
            echo '-javaagent:${(final.callPackage ./jetbrains-agent.nix { })}/ja-netfilter/ja-netfilter.jar=jetbrains
--add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
--add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED'>> $out/goland/bin/goland64.vmoptions
            '';
          });
        };
    in
    flake-utils.lib.eachDefaultSystem
      (system:
        let pkgs = nixpkgs.legacyPackages.${system}; in
         rec {
            packages = {
              goland = pkgs.jetbrains-goland-ultimate-d;
            };
          }
        )
      // {
        overlays.default = overlay;
      };
}
