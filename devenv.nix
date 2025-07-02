{ pkgs, ... }:

{
  packages = [
    pkgs.ripgrep
  ];

  imports = [
    ./services
  ];

  env.PROJECT_NAMESPACE = "StarterTemplate";

  languages.nix.enable = true;

  scripts = {
    up.exec = "devenv processes up";
  };

  enterShell = "./etc/script/enter-shell.sh";

  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  devcontainer.enable = true;
}
