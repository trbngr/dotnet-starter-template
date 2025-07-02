{ ... }:
let
  hostname = "auth.local.starter-template.com";
  certPath = ".devenv/state/caddy/data/caddy/certificates/local/${hostname}";
in
{
  services.keycloak = {
    enable = true;
    settings = {
      hostname = "${hostname}";
    };
    sslCertificate = "${certPath}/${hostname}.crt";
    sslCertificateKey = "${certPath}/${hostname}.key";
    realms.starter-template = {
      path = "./etc/keycloak/realm.json";
      import = true;
      export = true;
    };
  };
}
