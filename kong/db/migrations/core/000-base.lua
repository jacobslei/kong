return {
  postgres = {
    -- TODO
    up = [[

    ]],
  },

  cassandra = {
    up = [[
      CREATE TABLE IF NOT EXISTS cluster_events(
        channel text,
        at      timestamp,
        node_id uuid,
        id      uuid,
        data    text,
        nbf     timestamp,
        PRIMARY KEY (channel, at, node_id, id)
      );



      CREATE TABLE IF NOT EXISTS services(
        partition       text,
        id              uuid,
        connect_timeout int,
        created_at      timestamp,
        host            text,
        name            text,
        path            text,
        port            int,
        protocol        text,
        read_timeout    int,
        retries         int,
        updated_at      timestamp,
        write_timeout   int,
        PRIMARY KEY     (partition, id)
      );
      CREATE INDEX IF NOT EXISTS services_name_idx ON services(name);



      CREATE TABLE IF NOT EXISTS routes(
        partition      text,
        id             uuid,
        created_at     timestamp,
        hosts          list<text>,
        methods        set<text>,
        paths          list<text>,
        preserve_host  boolean,
        protocols      set<text>,
        regex_priority int,
        service_id     uuid,
        strip_path     boolean,
        updated_at     timestamp,
        PRIMARY KEY    (partition, id)
      );
      CREATE INDEX IF NOT EXISTS routes_service_id_idx ON routes(service_id);



      CREATE TABLE IF NOT EXISTS ssl_servers_names(
        name               text,
        ssl_certificate_id uuid,
        created_at         timestamp,
        PRIMARY KEY        (name, ssl_certificate_id)
      );
      CREATE INDEX IF NOT EXISTS ssl_servers_names_ssl_certificate_id_idx
        ON ssl_servers_names(ssl_certificate_id);



      CREATE TABLE IF NOT EXISTS ssl_certificates(
        id         uuid PRIMARY KEY,
        cert       text,
        created_at timestamp,
        key        text
      );



      CREATE TABLE IF NOT EXISTS consumers(
        id uuid    PRIMARY KEY,
        created_at timestamp,
        custom_id  text,
        email      text,
        meta       text,
        status     int,
        type       int,
        username   text
      );
      CREATE INDEX IF NOT EXISTS consumers_type_idx ON consumers(type);
      CREATE INDEX IF NOT EXISTS consumers_status_idx ON consumers(status);
      CREATE INDEX IF NOT EXISTS consumers_username_idx ON consumers(username);
      CREATE INDEX IF NOT EXISTS consumers_custom_id_idx ON consumers(custom_id);



      CREATE TABLE IF NOT EXISTS plugins(
        id          uuid,
        name        text,
        api_id      uuid,
        config      text,
        consumer_id uuid,
        created_at  timestamp,
        enabled     boolean,
        route_id    uuid,
        service_id  uuid,
        PRIMARY KEY (id, name)
      );
      CREATE INDEX IF NOT EXISTS plugins_name_idx ON plugins(name);
      CREATE INDEX IF NOT EXISTS plugins_api_id_idx ON plugins(api_id);
      CREATE INDEX IF NOT EXISTS plugins_route_id_idx ON plugins(route_id);
      CREATE INDEX IF NOT EXISTS plugins_service_id_idx ON plugins(service_id);
      CREATE INDEX IF NOT EXISTS plugins_consumer_id_idx ON plugins(consumer_id);



      CREATE TABLE IF NOT EXISTS upstreams(
        id                   uuid PRIMARY KEY,
        created_at           timestamp,
        hash_fallback        text,
        hash_fallback_header text,
        hash_on              text,
        hash_on_header       text,
        healthchecks         text,
        name                 text,
        slots                int
      );
      CREATE INDEX IF NOT EXISTS upstreams_name_idx ON upstreams(name);



      CREATE TABLE IF NOT EXISTS targets(
        id          uuid PRIMARY KEY,
        created_at  timestamp,
        target      text,
        upstream_id uuid,
        weight      int
      );
      CREATE INDEX IF NOT EXISTS targets_upstream_id_idx ON targets(upstream_id);
      CREATE INDEX IF NOT EXISTS targets_target_idx ON targets(target);



      CREATE TABLE IF NOT EXISTS apis(
        id                       uuid PRIMARY KEY,
        created_at               timestamp,
        hosts                    text,
        http_if_terminated       boolean,
        https_only               boolean,
        methods                  text,
        name                     text,
        preserve_host            boolean,
        retries                  int,
        strip_uri                boolean,
        upstream_connect_timeout int,
        upstream_read_timeout    int,
        upstream_send_timeout    int,
        upstream_url             text,
        uris                     text
      );
      CREATE INDEX IF NOT EXISTS apis_name_idx ON apis(name);
    ]],
  },
}
