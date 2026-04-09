job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]

  // must have linux for network mode
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "radarr" {
    count = 1

    [[ template "volumes_sources" . ]]

    network {
      port "http" {
        to = 7878
      }
    }

    service {
      name = "[[ template "job_name" . ]]-radarr"
      port = "http"
    }

    task "radarr" {
      driver = "docker"

      config {
        image = "linuxserver/radarr:[[ var "version_tag" . ]]"
        ports = ["http"]
	[[ template "volumes_docker" . ]]
      }

      [[ template "volumes_mounts" . ]]
    }
  }
}
