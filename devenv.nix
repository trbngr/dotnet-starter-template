{ pkgs, ... }:

{
  packages = [
    pkgs.ripgrep
  ];

  languages.nix.enable = true;

  services = {
    rabbitmq = {
      enable = true;
    };

    keycloak = {
      enable = true;
      realms.deepstaging = {
        path = "./etc/keycloak/realm.json";
        import = true;
        export = true;
      };
    };

    postgres = {
      enable = true;
      port = 5435;
      listen_addresses = "127.0.0.1";
      initialScript = "CREATE ROLE postgres SUPERUSER;";
      initialDatabases = [
        {
          name = "demo";
          user = "postgres";
          pass = "postgres";
        }
      ];
    };
  };

  scripts = {
    up.exec = "devenv processes up";
    change-namespace.exec = "$DEVENV_ROOT/etc/script/change-namespace.sh";
  };

  enterShell = ''
    echo "------------"
    git --version
    echo "dotnet version $(dotnet --version)"
    echo "pnpm version $(pnpm --version)"
    echo "node version $(node --version)"
    echo "typescript $(tsc --version)"
    echo ""
    echo "------------"
    dotnet tool restore --tool-manifest "$DEVENV_ROOT/.config/dotnet-tools.json"
    echo "------------"
  '';

  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  devcontainer.enable = true;
}
