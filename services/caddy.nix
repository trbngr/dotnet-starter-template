{
  services.caddy.enable = true;

  services.caddy.virtualHosts."local.starter_template.com" = {
    serverAliases = [ ];
    extraConfig = ''
      reverse_proxy http://127.0.0.1:4200
      tls internal
    '';
  };

  services.caddy.virtualHosts."auth.starter_template.com" = {
    serverAliases = [ ];
    extraConfig = ''
      reverse_proxy http://localhost:8080
      tls internal
    '';
  };
}
