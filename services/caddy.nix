{ ... }:
{
  services.caddy.enable = true;

  services.caddy.virtualHosts."web.local.starter-template.com" = {
    serverAliases = [ ];
    extraConfig = ''
      reverse_proxy http://127.0.0.1:4200
      tls internal
      log {
        level INFO
        output file ./var/log/caddy/frontend.log {
          roll_size 10MiB
          roll_keep 10
          roll_keep_for 336h
        }
      }
    '';
  };

  env.KC_PROXY_HEADERS = "xforwarded";

  services.caddy.virtualHosts."auth.local.starter-template.com" = {
    serverAliases = [ ];
    extraConfig = ''
      reverse_proxy http://127.0.0.1:8080 {
          header_up X-Forwarded-Proto https
          header_up X-Forwarded-For {remote_host}
          header_up X-Forwarded-Host {host}
          header_up Host {host}
      }

      tls internal

      log {
        level INFO
        output file ./var/log/caddy/keycloak.log {
          roll_size 10MiB
          roll_keep 10
          roll_keep_for 336h
        }
      }
    '';
  };

  scripts = {
    view-frontend.exec = "open https://web.local.starter-template.com";
    view-auth.exec = "open https://auth.local.starter-template.com";
  };
}
