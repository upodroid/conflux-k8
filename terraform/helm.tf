provider "helm" {
  install_tiller = true
  service_account = "tiller"


  kubernetes {
    host                   = "${google_container_cluster.maker.endpoint}"
    client_certificate     = "${base64decode(google_container_cluster.maker.master_auth.0.client_certificate)}"
    client_key             = "${base64decode(google_container_cluster.maker.master_auth.0.client_key)}"
    cluster_ca_certificate = "${base64decode(google_container_cluster.maker.master_auth.0.cluster_ca_certificate)}"
    
  }
}

resource "helm_release" "postgresql" {
  name  = "postgresql"
  chart = "stable/nginx-ingress"

     set {
        name  = "postgresqlDatabase"
        value = "gitlab"
    }

}
