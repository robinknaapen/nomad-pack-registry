job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]

  // must have linux for network mode
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  [[- if var "volumes.data" . ]]
  volume "data" {
    type = [[ var "volumes.data.type" . | quote ]]
    source = [[ var "volumes.data.source" . | quote ]]
    read_only = false
  }
  [[- end ]]

  group "netbird" {
    count = 1

    [[ template "vault" . ]]

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
      name = "dashboard"
      port = "dashboard"
    }

    service {
      name = "server"
      port = "server"
    }

    service {
      name = "vpn"
      port = "vpn"
    }

    task "dashboard" {
      driver = "docker"

      template {
        data = <<EOF
          [[ var "dashboard_env" . ]]
        EOF
        destination = "secrets/dashboard.env"
        env = true
      }

      config {
        image = "netbirdio/dashboard:[[ var "dashboard_version_tag" . ]]"
        ports = ["dashboard"]
      }
    }

    task "server" {
      driver = "docker"

      volume_mount {
        source = "data"
        destination = "/var/lib/netbird"
      }

      template {
        data = <<EOF
          [[ var "server_config" . ]]
        EOF
        destination = "/local/etc/netbird/config.yaml"
      }

      config {
        image = "netbirdio/netbird-server:[[ var "server_version_tag" . ]]"
        ports = ["server", "vpn"]
        args = [
          "--config"
          "/etc/netbird/config.yaml"
        ]
      }
    }
  }
}
