resource "google_container_cluster" "maker" {
  name                     = "maker"
  zone                     = "${var.zone}"
  remove_default_node_pool = true
  network = "${google_compute_network.dev-test.name}"
  subnetwork = "${google_compute_subnetwork.dev-test-uk.name}"

  node_pool {
    name = "primary-pool"
  }
}

resource "google_container_node_pool" "primary_pool" {
  name       = "primary-pool"
  cluster    = "${google_container_cluster.maker.name}"
  zone       = "${var.zone}"
  node_count = "3"

  node_config {
    machine_type = "n1-standard-2"
    disk_type = "pd-ssd"
    disk_size_gb = 50
    image_type = "ubuntu"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}