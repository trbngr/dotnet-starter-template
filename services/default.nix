{
  imports = [
    ./caddy.nix
    ./keycloak.nix
    ./postgres.nix
  ];

  services.rabbitmq = {
    enable = true;
  };
}
