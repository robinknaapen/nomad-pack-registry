job [[ var "job_name" . | quote ]] {
  [[- template "region" . ]]
  datacenters = [[ var "datacenters" . | toStringList ]]
  node_pool   = [[ var "node_pool" . | quote ]]

  group "audiobookshelf" {
    count = 1

    [[- with (var "volume_config" .) ]]

    volume "config" {
      source          = [[ .source | quote ]]
      type            = [[ .type | quote ]]
      [[- with .access_mode ]]
      access_mode     = [[ . | quote ]]
      [[- end ]]
      [[- with .attachment_mode ]]
      attachment_mode = [[ . | quote ]]
      [[- end ]]
      [[- with .read_only ]]
      read_only = [[ . ]]
      [[- end ]]
    }
    [[- end ]]

    [[- with (var "volume_podcasts" .) ]]

    volume "podcasts" {
      source          = [[ .source | quote ]]
      type            = [[ .type | quote ]]
      [[- with .access_mode ]]
      access_mode     = [[ . | quote ]]
      [[- end ]]
      [[- with .attachment_mode ]]
      attachment_mode = [[ . | quote ]]
      [[- end ]]
      [[- with .read_only ]]
      read_only = [[ . ]]
      [[- end ]]
    }
    [[- end ]]

    [[- with (var "volume_metadata" .) ]]

    volume "metadata" {
      source          = [[ .source | quote ]]
      type            = [[ .type | quote ]]
      [[- with .access_mode ]]
      access_mode     = [[ . | quote ]]
      [[- end ]]
      [[- with .attachment_mode ]]
      attachment_mode = [[ . | quote ]]
      [[- end ]]
      [[- with .read_only ]]
      read_only = [[ . ]]
      [[- end ]]
    }
    [[- end ]]

    [[- with (var "volume_audiobooks" .) ]]

    volume "audiobooks" {
      source          = [[ .source | quote ]]
      type            = [[ .type | quote ]]
      [[- with .access_mode ]]
      access_mode     = [[ . | quote ]]
      [[- end ]]
      [[- with .attachment_mode ]]
      attachment_mode = [[ . | quote ]]
      [[- end ]]
      [[- with .read_only ]]
      read_only = [[ . ]]
      [[- end ]]
    }
    [[- end ]]

    [[- template "vault" . ]]

    network {
      port "http" {
        to = "80"
      }
    }

    service {
      name = [[ printf "%s-%s" (var "job_name" .) "audiobookshelf" | quote ]]
      port = "http"
    }

    task "audiobookshelf" {
      driver = "docker"
      user   = [[ var "user" . | quote ]]

      config {
        image = "advplyr/audiobookshelf:[[ var "version_tag" . ]]"
        ports = ["http"]
      }

      [[- with (var "config" .) ]]
      template {
        data = <<EOF
        [[ . ]]
        EOF
        destination = "secrets/config"
        env = true
      }
      [[- end ]]

      [[- with (var "volume_config" .) ]]

      volume_mount {
        volume      = "config"
        destination = [[ .destination | quote ]]
        [[- with .read_only ]]
        read_only = [[ . ]]
        [[- end ]]
      }
      [[- end ]]

      [[- with (var "volume_podcasts" .) ]]

      volume_mount {
        volume      = "podcasts"
        destination = [[ .destination | quote ]]
        [[- with .read_only ]]
        read_only = [[ . ]]
        [[- end ]]
      }
      [[- end ]]

      [[- with (var "volume_audiobooks" .) ]]

      volume_mount {
        volume      = "audiobooks"
        destination = [[ .destination | quote ]]
        [[- with .read_only ]]
        read_only = [[ . ]]
        [[- end ]]
      }
      [[- end ]]

      [[- with (var "volume_metadata" .) ]]

      volume_mount {
        volume      = "metadata"
        destination = [[ .destination | quote ]]
        [[- with .read_only ]]
        read_only = [[ . ]]
        [[- end ]]
      }
      [[- end ]]
    }
  }
}
