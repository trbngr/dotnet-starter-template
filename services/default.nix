{
  imports = [
    ./caddy.nix
  ];

  services = {
    keycloak = {
      enable = true;
      realms.starter_template = {
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
          name = "starter_template";
          user = "postgres";
          pass = "postgres";
        }
      ];
    };

    rabbitmq = {
      enable = true;
    };
  };
}
