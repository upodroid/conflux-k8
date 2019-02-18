provider "google" {
  credentials = "${file("~/ansible.json")}"
  project     = "${var.project_id}"
  region      = "${var.region}"
  zone        = "${var.zone}"
  ## 1043621432180 Project ID
}

terraform {
  backend "gcs" {
    bucket  = "uraniferous"
    prefix  = "terraform"
    credentials = "~/ansible.json"
  }
}