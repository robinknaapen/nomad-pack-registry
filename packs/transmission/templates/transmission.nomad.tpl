job [[ var "job_name" . | quote ]] {
  [[- template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]

  // must have linux for network mode
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "transmission" {
    count = 1

    [[- template "vault" . ]]

    [[- template "volumes_sources" . ]]

    network {
      port "ui" {
        to = 9091
      }
      port "p2p" {
        to = "51413"
      }
    }

    service {
      name = [[ printf "%s-%s" (var "job_name" .) "transmission" | quote ]]
      port = "ui"
    }

    service {
      name = [[ printf "%s-%s" (var "job_name" .) "p2p" | quote ]]
      port = "p2p"
    }

    task "transmission" {
      driver = "docker"

      [[- if (var "env" .) ]]
      template {
        data = <<EOF
        [[ var "env" . ]]
        EOF
        destination = "secrets/env"
        env = true
      }
      [[- end ]]

      config {
        image = "linuxserver/transmission:[[ var "version_tag" . ]]"
        ports = ["ui", "p2p"]
        [[- template "volumes_docker" . ]]
      }

      [[- if (or (var "puid" .) (var "pgid" .)) ]]

      env {
        [[- if (var "puid" .) ]]
        PUID = [[ var "puid" . | quote ]]
        [[- end ]]
        [[- if (var "pgid" .) ]]
        PGID = [[ var "pgid" . | quote ]]
        [[- end ]]
      }
      [[- end ]]

      [[- template "volumes_mounts" . ]]
    }
  }
}
