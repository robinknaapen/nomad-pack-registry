job [[ var "job_name" . | quote ]] {
  [[- template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]

  group "ha" {
    count = 1

    [[- template "volumes_sources" . ]]

    [[- template "vault" . ]]

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
      user   = [[ var "user" . | quote ]]

      config {
        image = "linuxserver/homeassistant:[[ var "version_tag" . ]]"
        args = [
          [[ var "root" . | quote ]]
        ]
        ports = ["ui"]
      }

      [[- template "volumes_mounts" . ]]
    }
  }
}
