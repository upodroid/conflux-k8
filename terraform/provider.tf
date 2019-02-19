provider "google" {
  project     = "${var.project_id}"
  region      = "${var.region}"
  zone        = "${var.zone}"
  ## 1043621432180 Project ID
}

provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "$HOME/.aws/credentials"
}

terraform {
  backend "gcs" {
    bucket  = "uraniferous"
    prefix  = "terraform"
  }
}