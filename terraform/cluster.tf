module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = ""
  name                       = "maker"
  region                     = "${var.region}"
  network                    = "${var.network}"
  subnetwork                 = "us-central1-01"
  ip_range_pods              = "us-central1-01-gke-01-pods"
  ip_range_services          = "us-central1-01-gke-01-services"
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  kubernetes_dashboard       = true
  network_policy             = true
  kubernetes_version         = "latest"


  node_pools = [
    {
      name            = "default-node-pool"
      machine_type    = "n1-standard-2"
      min_count       = 3
      max_count       = 10
      disk_size_gb    = 100
      disk_type       = "pd-ssd"
      image_type      = "ubuntu"
      auto_repair     = true
      auto_upgrade    = true
      service_account = "project-service-account@.iam.gserviceaccount.com"
      preemptible     = false
    },
  ]

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = "true"
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}