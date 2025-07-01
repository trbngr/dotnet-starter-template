{ pkgs, ... }:
{
  packages = [
    pkgs.jetbrains.rider
  ];

  languages = {
    dotnet = {
      enable = true;
      package = (
        pkgs.dotnetCorePackages.combinePackages [
          # optional sdks
          # pkgs.dotnet-sdk_10
          pkgs.dotnet-sdk_9
        ]
      );
    };
  };

  scripts = {
    develop-backend.exec = "rider $DEVENV_ROOT/backend/api/api.slnx";

    clean-backend.exec = ''
      find "$DEVENV_ROOT/backend" -type d \( -name "bin" -o -name "obj" \) -exec rm -rf {} +
    '';
  };
}
