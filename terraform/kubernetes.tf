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
  secret {
    name = "${kubernetes_secret.tiller-secret.metadata.0.name}"
  }
}

resource "kubernetes_secret" "tiller-secret" {
  metadata {
    name = "terraform-tiller"
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
}

resource "kubernetes_secret" "ssl" {
  metadata {
    name = "upodroid_com_tls"
  }

  data {
    cert = "${file("~/sendgrid.txt")}"
    key = "${file("~/sendgrid.txt")}"
  }

  type = "kubernetes.io/tls"
}
