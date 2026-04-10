job [[ var "job_name" . | quote ]] {
  [[- template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]

  // must have linux for network mode
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "netbird" {
    count = 1

    [[- if var "volumes" . ]]
    volume "data" {
      type = [[ var "volumes.data.type" . | quote ]]
      source = [[ var "volumes.data.source" . | quote ]]
      access_mode     = [[ var "volumes.data.access_mode" . | quote ]]
      attachment_mode = [[ var "volumes.data.attachment_mode" . | quote ]]
    }
    [[- end ]]

    [[- template "vault" . ]]

    network {
      port "dashboard" {
        to = 80
      }

      port "server" {
        to = 80
      }

      port "vpn" {
        to = 3478
      }
    }

    service {
      name = [[ printf "%s-%s" (var "job_name" .) "dashboard" | quote ]]
      port = "dashboard"
    }

    service {
      name = [[ printf "%s-%s" (var "job_name" .) "server" | quote ]]
      port = "server"
    }

    service {
      name = [[ printf "%s-%s" (var "job_name" .) "vpn" | quote ]]
      port = "vpn"
    }

    task "dashboard" {
      driver = "docker"

      template {
        data = <<EOF
        [[ var "dashboard_env" . ]]
        EOF
        destination = "secrets/dashboard_env"
        env = true
      }

      config {
        image = "netbirdio/dashboard:[[ var "dashboard_version_tag" . ]]"
        ports = ["dashboard"]
      }
    }

    task "server" {
      driver = "docker"

      [[- if var "volumes" . ]]
      volume_mount {
        volume = "data"
        destination = "/var/lib/netbird"
      }
      [[- end ]]

      template {
        data = <<EOF
        [[ var "server_config" . ]]
        EOF
        destination = "secrets/config.yaml"
      }

      config {
        image = "netbirdio/netbird-server:[[ var "server_version_tag" . ]]"
        ports = ["server", "vpn"]
        args = [
          "--config",
          "/etc/netbird/config.yaml"
        ]
        volumes = [
          "secrets/config.yaml:/etc/netbird/config.yaml"
        ]
      }
    }
  }
}
