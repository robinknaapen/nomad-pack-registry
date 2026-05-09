job [[ var "job_name" . | quote ]] {
  [[- template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]

  group "home-assistant-matter-hub" {
    count = 1

    [[- template "vault" . ]]

    [[- template "volumes_sources" . ]]

    network {
      mode = "host"

      port "ui" {
        to = "8482"
      }

      port "mdns" {
        static = "5353"
        to = "5353"
      }

      port "bridge" {
        static = "5540"
        to = "5540"
      }
    }

    service {
      name = [[ printf "%s-%s" (var "job_name" .) "ui" | quote ]]
      port = "ui"
    }

    service {
      name = [[ printf "%s-%s" (var "job_name" .) "bridge" | quote ]]
      port = "bridge"
    }

    task "home-assistant-matter-hub" {
      driver = "docker"
      network_mode = "host"

      config {
        image = "ghcr.io/riddix/home-assistant-matter-hub:[[ var "version_tag" . ]]"
        ports = ["ui", "mdns", "bridge"]
      }

      [[- if (var "env" .) ]]
      template {
        data = <<EOF
        [[ var "env" . ]]
        EOF
        destination = "secrets/env"
        env = true
      }
      [[- end ]]

      env = {
        HAMH_HTTP_PORT = 8482
      }

      [[- template "resources" . ]]

      [[- template "volumes_mounts" . ]]
    }
  }
}
