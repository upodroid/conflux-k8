provider "google" {
  project     = "${var.project_id}"
  region      = "${var.region}"
  zone        = "${var.zone}"
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
