{ ... }:
let
  textUtils = {
    to-pascal-case.exec = ''$DEVENV_ROOT/etc/script/text/to-pascal-case.sh "$@";'';
    to-snake-case.exec = ''$DEVENV_ROOT/etc/script/text/to-snake-case.sh "$@";'';
    to-kebab-case.exec = ''$DEVENV_ROOT/etc/script/text/to-kebab-case.sh "$@";'';
  };

  repoUtils = {
    change-namespace.exec = "./etc/script/change-namespace.sh";

    create-new-library.exec = ''
      $DEVENV_ROOT/etc/script/create-new-project.sh \
        --project-type library \
        --name "$1";
    '';

    create-new-module.exec = ''
      $DEVENV_ROOT/etc/script/create-new-project.sh \
        --project-type module \
        --name "$1";
    '';
  };
in
{
  scripts = textUtils // repoUtils;
}
