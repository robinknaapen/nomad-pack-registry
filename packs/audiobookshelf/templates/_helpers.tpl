[[- define "region" ]]
[[- if not (eq (var "region" .) "") ]]
region = [[ var "region" . | quote]]
[[- end ]]
[[- end ]]

[[- define "vault" ]]
[[- if var "vault" . ]]

vault {
  change_mode   = "noop"
}
[[- end ]]
[[- end ]]
