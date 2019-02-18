variable "project_id" {
  default = "peerless-text-229510"
}


variable "name" {
  default = "tf-default"
}

variable "machine_type" {
  default = "g1-small"
}

variable "zone" {
  description = "Default Zone"
  default     = "europe-west2-b"
}

variable "region" {
  description = "Default Region"
  default     = "europe-west2"
}

variable "network" {
  default = "dev-test"
}
