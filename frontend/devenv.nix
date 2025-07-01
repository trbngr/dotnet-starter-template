{ pkgs, inputs, ... }:
let
  pkgs-upstream = import inputs.nixpkgs-upstream { system = pkgs.stdenv.system; };
in
{
  packages = [
  ];

  languages = {
    typescript.enable = true;

    javascript = {
      enable = true;
      package = pkgs-upstream.nodejs_24;
      pnpm = {
        enable = true;
        install.enable = true;
      };
    };
  };

  scripts = {
    develop-frontend.exec = "code $DEVENV_ROOT/frontend";
  };
}
