[[- define "region" ]]
[[- if not (eq (var "region" .) "") ]]
region = [[ var "region" . | quote]]
[[- end ]]
[[- end ]]

[[- define "volumes_sources" ]]
[[- range $mount := (var "volumes.mounts" .) ]]

volume [[ $mount.name | quote ]] {
  source          = [[ $mount.source | quote ]]
  type            = [[ $mount.type | quote ]]
  [[- with $mount.access_mode ]]
  access_mode     = [[ . | quote ]]
  [[- end ]]
  [[- with $mount.attachment_mode ]]
  attachment_mode = [[ . | quote ]]
  [[- end ]]
}
[[- end ]]
[[- end ]]

[[- define "volumes_mounts" ]]
[[- range $mount := (var "volumes.mounts" .) ]]

volume_mount {
  volume = [[ $mount.name | quote ]]
  destination = [[ $mount.destination | quote ]]
}
[[- end ]]
[[- end ]]

[[ define "volumes_docker" ]]
[[- if not (eq (len (var "volumes.docker" .)) 0) ]]
volumes = [[ var "volumes.docker" . | toStringList ]]
[[- end ]]
[[- end ]]

[[- define "connect" ]]
[[- if var "connect" . ]]

connect {
  sidecar_service {
    proxy {
      transparent_proxy {
          exclude_inbound_ports = ["8989"]
      }
    }
  }
}
[[- end ]]
[[- end ]]
