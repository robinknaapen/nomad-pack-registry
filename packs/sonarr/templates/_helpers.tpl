// allow nomad-pack to set the job name

[[- define "job_name" -]]
[[- if eq (var "job_name" .) "" -]]
[[- meta "pack.name" . | quote -]]
[[- else -]]
[[- var "job_name" . | quote -]]
[[- end -]]
[[- end -]]

// only deploys to a region if specified

[[- define "region" -]]
[[- if not (eq (var "region" .) "") -]]
region = [[ var "region" . | quote]]
[[- end -]]
[[- end -]]

[[- define "volumes_sources" -]]
[[- range $mount := (var "volumes.mounts" .) -]]
volume [[ $mount.name | quote ]] {
  source          = [[ $mount.source | quote ]]
  type            = [[ $mount.type | quote ]]
  access_mode     = [[ $mount.access_mode | quote ]]
  attachment_mode = [[ $mount.attachment_mode | quote ]]
}
[[- end -]]
[[- end -]]

[[- define "volumes_mounts" -]]
[[- range $mount := (var "volumes.mounts" .) -]]
volume_mount {
  volume = [[ $mount.name | quote ]]
  destination = [[ $mount.destination | quote ]]
}
[[- end -]]
[[- end -]]

[[- define "volumes_docker" -]]
[[- if not (eq (len (var "volumes.docker" .)) 0) -]]
volumes = [[ var "volumes.docker" . | toStringList ]]
[[- end -]]
[[- end -]]
