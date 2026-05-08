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
  [[- with $mount.read_only ]]
  read_only = [[ . ]]
  [[- end ]]
}
[[- end ]]
[[- end ]]

[[- define "volumes_mounts" ]]
[[- range $mount := (var "volumes.mounts" .) ]]

volume_mount {
  volume = [[ $mount.name | quote ]]
  destination = [[ $mount.destination | quote ]]
  [[- with $mount.read_only ]]
  read_only = [[ . ]]
  [[- end ]]
}
[[- end ]]
[[- end ]]

[[ define "volumes_docker" ]]
[[- if not (eq (len (var "volumes.docker" .)) 0) ]]
volumes = [[ var "volumes.docker" . | toStringList ]]
[[- end ]]
[[- end ]]
