provider "google" {
  project     = "${var.project_id}"
  region      = "${var.region}"
  zone        = "${var.zone}"
  ## 1043621432180 Project ID
}

terraform {
  backend "gcs" {
    bucket  = "uraniferous"
    prefix  = "terraform"
  }
}