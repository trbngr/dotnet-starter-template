{

  services.postgres = {
    enable = true;
    port = 5435;
    listen_addresses = "127.0.0.1";
    initialScript = "CREATE ROLE postgres SUPERUSER;";
    initialDatabases = [
      {
        name = "starter-template";
        user = "postgres";
        pass = "postgres";
      }
    ];
  };
}
