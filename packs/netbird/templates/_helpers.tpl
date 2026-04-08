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
  type            = "host"
  access_mode     = "single-node-single-writer"
  attachment_mode = "file-system"
}
[[- end -]]
[[- end -]]

[[- if var "vault" . ]]
vault {
  policies = [[ var "vault" . | toStringList ]]
  change_mode   = "noop"
}
[[- end ]]
