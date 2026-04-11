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

variable "version_tag" {
  description = "The docker image version. For options, see https://hub.docker.com/linuxserver/sonarr"
  type        = string
  default     = "4.0.17"
}

variable "volumes" {
  description = "Configure volumes"

  type = object({
    mounts = list(object({
      source          = string
      type            = string
      access_mode     = string
      attachment_mode = string
    }))

    docker = list(string)
  })

  default = {
    mounts = []
    docker = []
  }
}

variable "puid" {
  description = "UID"
  type        = string
  default     = "1000"
}

variable "pgid" {
  description = "GID"
  type        = string
  default     = "1000"
}

variable "connect" {
  type = object({
    proxy = list(object({
      destination_name   = string
      local_bind_port    = number
      local_bind_address = string
    }))
  })

  default = {
    proxy = []
  }
}
