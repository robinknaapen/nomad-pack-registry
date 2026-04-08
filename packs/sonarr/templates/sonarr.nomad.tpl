job [[ template "job_name" . ]] {
  [[ template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]

  // must have linux for network mode
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "sonarr" {
    count = 1

    [[ template "volumes_sources" . ]]

    network {
      port "http" {
        to = 8989
      }
    }

    service {
      name = "sonarr"
      port = "http"
    }

    task "sonarr" {
      driver = "docker"

      config {
        image = "linuxserver/sonarr:[[ var "version_tag" . ]]"
        ports = ["http"]
	[[ template "volumes_docker" . ]]
      }

      [[ template "volumes_mounts" . ]]
    }
  }
}
