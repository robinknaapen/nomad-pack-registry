job [[ var "job_name" . | quote ]] {
  [[- template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]

  group "miniserve" {
    count = 1

    [[- template "volumes_sources" . ]]

    [[- template "vault" . ]]

    network {
      port "http" {
        to = "8080"
      }
    }

    service {
      name = [[ printf "%s-%s" (var "job_name" .) "miniserve" | quote ]]
      port = "http"
    }

    task "miniserve" {
      driver = "docker"
      user   = [[ var "user" . | quote ]]

      config {
        image = "svenstaro/miniserve:[[ var "version_tag" . ]]"
        args = [
          [[ var "root" . | quote ]]
        ]
        ports = ["http"]
      }

      template {
        data = <<EOF
        [[ var "env" . ]]
        MINISERVE_PORT=8080
        EOF
        destination = "secrets/env"
        env = true
      }
      
      [[- template "volumes_mounts" . ]]
    }
  }
}
