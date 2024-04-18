{
  description = "my project description";
  inputs.goland.url = "../";

  outputs = { self, nixpkgs, goland}:
  let pkgs = import nixpkgs {
    system = "x86_64-linux";
    overlays = [goland.overlays.default];
  }; in {
    packages.x86_64-linux.default = pkgs.jetbrains-goland-ultimate-d;
  };
}
