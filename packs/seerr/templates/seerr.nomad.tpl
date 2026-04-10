job [[ var "job_name" . | quote ]] {
  [[ template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]

  // must have linux for network mode
  constraint {
    attribute = "${attr.kernel.name}"
    value     = "linux"
  }

  group "seerr" {
    count = 1

    [[ template "volumes_sources" . ]]

    network {
      port "http" {
        to = 5055
      }
    }

    service {
      name = [[ printf "%s-%s" (var "job_name" .) "seerr" | quote ]]
      port = "http"
    }

    task "seerr" {
      driver = "docker"

      config {
        image = "ghcr.io/seerr-team/seerr:[[ var "version_tag" . ]]"
        ports = ["http"]
	[[ template "volumes_docker" . ]]
      }

      [[ template "volumes_mounts" . ]]
    }
  }
}
