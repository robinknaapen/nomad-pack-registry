job [[ var "job_name" . | quote ]] {
  [[- template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]

  // must have linux for network mode
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "radarr" {
    count = 1

    [[- template "volumes_sources" . ]]

    network {
      port "http" {
        to = 7878
      }
    }

    service {
      name = [[ printf "%s-%s" (var "job_name" .) "radarr" | quote ]]
      port = "http"

      [[- template "connect" . ]]
    }

    task "radarr" {
      driver = "docker"

      config {
        image = "linuxserver/radarr:[[ var "version_tag" . ]]"
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
