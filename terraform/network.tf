resource "google_compute_address" "gke_ip_address" {
  name = "gke"
  address_type = "EXTERNAL"
  region = "${var.region}"
}

resource "google_compute_network" "dev-test" {
  name                    = "${var.network}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "dev-test-uk" {
  name          = "dev-test-uk"
  ip_cidr_range = "10.0.1.0/24"
  region        = "${var.region}"
  network       = "${google_compute_network.dev-test.self_link}"
}

output "external_ip" {
  value = "${google_compute_address.gke_ip_address.address}"
}