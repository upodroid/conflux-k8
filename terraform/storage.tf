resource "google_storage_bucket" "quadrennium" {
  name = "quadrennium"
  location = "EU"
  storage_class = "MULTI_REGIONAL"
}

resource "google_storage_bucket" "quadrennium-lfs" {
  name = "quadrennium-lfs"
  location = "EU"
  storage_class = "MULTI_REGIONAL"
}

resource "google_storage_bucket" "quadrennium-uploads" {
  name = "quadrennium-uploads"
  location = "EU"
  storage_class = "MULTI_REGIONAL"
}

resource "google_storage_bucket" "quadrennium-packs" {
  name = "quadrennium-packs"
  location = "EU"
  storage_class = "MULTI_REGIONAL"
}

resource "google_storage_bucket" "quadrennium-pse" {
  name = "quadrennium-pse"
  location = "EU"
  storage_class = "MULTI_REGIONAL"
}

resource "google_storage_bucket" "quadrennium-artifacts" {
  name = "quadrennium-artifacts"
  location = "EU"
  storage_class = "MULTI_REGIONAL"
}

resource "google_storage_bucket" "quadrennium-backups" {
  name = "quadrennium-backups"
  location = "EU"
  storage_class = "MULTI_REGIONAL"
}

resource "google_storage_bucket" "quadrennium-tmp" {
  name = "quadrennium-tmp"
  location = "EU"
  storage_class = "MULTI_REGIONAL"
}