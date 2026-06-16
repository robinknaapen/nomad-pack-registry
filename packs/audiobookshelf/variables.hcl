# Copyright IBM Corp. 2021, 2025
# SPDX-License-Identifier: MPL-2.0

variable "job_name" {
  description = "The name to use as the job name which overrides using the pack name"
  type        = string
  default     = "audiobookshelf"
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
  description = "The docker image version. For options, see https://hub.docker.com/r/advplyr/audiobookshelf"
  type        = string
  default     = "2.35.1"
}

variable "volume_audiobooks" {
  description = "audiobooks volumes"

  type = object({
    source          = string
    type            = string
    access_mode     = string
    attachment_mode = string
    read_only       = optional(bool)
  })

  default = {}
}

variable "volume_podcasts" {
  description = "podcasts volumes"

  type = object({
    source          = string
    type            = string
    access_mode     = string
    attachment_mode = string
    read_only       = optional(bool)
  })

  default = {}
}

variable "volume_metadata" {
  description = "metadata volumes"

  type = object({
    source          = string
    type            = string
    access_mode     = string
    attachment_mode = string
    read_only       = optional(bool)
  })

  default = {}
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

variable "config" {
  description = "config"
  type        = string
  default     = ""
}

variable "env" {
  description = "env"
  type        = string
  default     = ""
}
