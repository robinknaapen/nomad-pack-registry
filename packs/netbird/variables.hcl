# Copyright IBM Corp. 2021, 2025
# SPDX-License-Identifier: MPL-2.0

variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name"
  type        = string
  // If "", the pack name will be used
  default = ""
}

variable "datacenters" {
  description = "A list of datacenters in the region which are eligible for task placement"
  type        = list(string)
  default     = ["dc1"]
}

variable "node_pool" {
  description = "The node pool where the job should be placed."
  type        = string
  default     = "default"
}

variable "region" {
  description = "The region where the job should be placed"
  type        = string
  default     = "global"
}

variable "dashboard_version_tag" {
  description = "The docker image version. For options, see https://hub.docker.com/r/netbirdio/dashboard"
  type        = string
  default     = "latest"
}

variable "server_version_tag" {
  description = "The docker image version. For options, see https://hub.docker.com/r/netbirdio/netbird-server"
  type        = string
  default     = "latest"
}

variable "vault" {
  description = "Use vault"
  type        = bool
  default     = false
}

variable "dashboard_env" {
  description = "dashboard env"
  type        = string
}

variable "server_config" {
  description = "/etc/netbird/config.yml"
  type        = string
}

variable "volumes" {
  description = "Configuration for volumes to be mounted in the job"
  type = object({
    data = object({
      type            = string
      source          = string
      access_mode     = string
      attachment_mode = string
    })
  })
}
