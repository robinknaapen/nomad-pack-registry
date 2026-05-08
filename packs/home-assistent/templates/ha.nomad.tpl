job [[ var "job_name" . | quote ]] {
  [[- template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]

  group "ha" {
    count = 1

    [[- template "volumes_sources" . ]]

    network {
      port "ui" {
        to = "8123"
      }
    }

    service {
      name = [[ printf "%s-%s" (var "job_name" .) "ha" | quote ]]
      port = "ui"
    }

    task "ha" {
      driver = "docker"

      config {
        image = "ghcr.io/home-assistant/home-assistant:[[ var "version_tag" . ]]"
        ports = ["ui"]
      }

      [[- template "resources" ]]

      [[- template "volumes_mounts" . ]]
    }
  }
}
