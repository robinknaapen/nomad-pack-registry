job [[ var "job_name" . | quote ]] {
  [[- template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]

  group "matterbridge" {
    count = 1

    [[- template "volumes_sources" . ]]

    network {
      port "ui" {
        to = "8585"
      }

      port "bridge" {
        to = "5540"
      }
    }

    service {
      name = [[ printf "%s-%s" (var "job_name" .) "ui" | quote ]]
      port = "ui"
    }

    service {
      name = [[ printf "%s-%s" (var "job_name" .) "bridge" | quote ]]
      port = "bridge"
    }

    task "matterbridge" {
      driver = "docker"

      config {
        image = "luligu/matterbridge:[[ var "version_tag" . ]]"

        args = [
          "matterbridge", "--docker",
          "--port", "5540",
          "--frontent", "8585"
        ]

        ports = ["ui", "bridge"]
      }

      [[- template "resources" . ]]

      [[- template "volumes_mounts" . ]]
    }
  }
}
