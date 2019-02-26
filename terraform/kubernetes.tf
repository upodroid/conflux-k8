resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller-role-binding"
  }
  subject {
    api_group = "rbac.authorization.k8s.io"
    kind = "User"
    name = "system:serviceaccount:kube-system:tiller"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "cluster-admin"
  }
}

resource "kubernetes_service_account" "tiller" {
  metadata {
    name = "tiller"
  }
  depends_on = ["google_container_cluster.maker"]
  secret {
    name = "${kubernetes_secret.tiller-secret.metadata.0.name}"
  }
}

resource "kubernetes_secret" "tiller-secret" {
  metadata {
    name = "terraform-tiller"
    depends_on = ["google_container_cluster.maker"]
  }
}

resource "kubernetes_secret" "sendgrid-apikey" {
  metadata {
    name = "sendgrid-apikey"
  }
  data {
    "password" = "${file("~/sendgrid.txt")}"
  }
  type = "generic"
  depends_on = ["google_container_cluster.maker"]
}

resource "kubernetes_secret" "ssl" {
  metadata {
    name = "upodroid-com-tls"
  }

  data {
    crt = "${file("~/certs/cert.pem")}"
    key = "${file("~/certs/key.pem")}"
  }

  type = "kubernetes.io/tls"
  depends_on = ["google_container_cluster.maker"]
}
