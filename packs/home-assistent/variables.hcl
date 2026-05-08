# Copyright IBM Corp. 2021, 2025
# SPDX-License-Identifier: MPL-2.0

variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name"
  type        = string
  default     = "ha"
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
  description = "The docker image version"
  type        = string
  default     = "stable"
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

variable "resources" {
  description = "Configure resources"

  type = object({
    cpu        = number
    memory     = number
    memory_max = number
  })

  default = {
    cpu        = 0
    memory     = 0
    memory_max = 0
  }
}
