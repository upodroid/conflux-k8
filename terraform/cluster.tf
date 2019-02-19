resource "google_container_cluster" "maker" {
  name   = "maker"
  region = "${var.region}"
  network = "${google_compute_network.dev-test.self_link}"
  subnetwork = "${google_compute_subnetwork.dev-net-uk.self_link}"

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count = 1

  # Setting an empty username and password explicitly disables basic auth
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = "dev"
    }
  }
}

resource "google_container_node_pool" "mainpool" {
  name       = "main-node-pool"
  region     = "${var.region}"
  cluster    = "${google_container_cluster.maker.name}"
  node_count = 3

  node_config {
    preemptible  = false
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

# The following outputs allow authentication and connectivity to the GKE Cluster
# by using certificate-based authentication.
output "client_certificate" {
  value = "${google_container_cluster.maker.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.maker.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.maker.master_auth.0.cluster_ca_certificate}"
}