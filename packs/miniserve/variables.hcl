# Copyright IBM Corp. 2021, 2025
# SPDX-License-Identifier: MPL-2.0

variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name"
  type        = string
  default     = "miniserve"
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
  description = "The docker image version. For options, see https://hub.docker.com/r/svenstaro/miniserve"
  type        = string
  default     = "0.35.0-alpine"
}

variable "volumes" {
  description = "Configure volumes"

  type = object({
    mounts = list(object({
      source          = string
      type            = string
      access_mode     = string
      attachment_mode = string
      read_only       = bool
    }))

    docker = list(string)
  })

  default = {
    mounts = []
    docker = []
  }
}

variable "vault" {
  description = "Use vault"
  type        = bool
  default     = false
}

variable "user" {
  description = "User for Docker"
  type        = string
  default     = "1000:1000"
}

variable "env" {
  description = "env"
  type        = string
  default     = ""
}

variable "root" {
  description = "Root path to serve"
  type        = string
}
