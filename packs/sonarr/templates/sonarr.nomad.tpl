job [[ var "job_name" . | quote ]] {
  [[- template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]

  // must have linux for network mode
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "sonarr" {
    count = 1

    [[- template "volumes_sources" . ]]

    network {
      port "http" {
        to = 8989
      }
    }

    service {
      name = [[ printf "%s-%s" (var "job_name" .) "sonarr" | quote ]]
      port = "http"
    }

    task "sonarr" {
      driver = "docker"

      config {
        image = "linuxserver/sonarr:[[ var "version_tag" . ]]"
        ports = ["http"]
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
