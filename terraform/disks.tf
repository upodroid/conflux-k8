resource "google_compute_disk" "redis" {
  name  = "redis-pv"
  type  = "pd-ssd"
  size = 20
  zone  = "${var.zone}"
  labels = {
    environment = "dev"
  }
}

resource "google_compute_disk" "postgresql" {
  name  = "postgresql-pv"
  type  = "pd-ssd"
  size = 20
  zone  = "${var.zone}"
  labels = {
    environment = "dev"
  }
}