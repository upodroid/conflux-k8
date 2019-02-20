resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
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

resource "kubernetes_secret" "sendgrid-apikey" {
  metadata {
    name = "sendgrid-apikey"
  }
  data {
    "password" = "${file("~/sendgrid.txt")}"
  }
  type = "generic"
}