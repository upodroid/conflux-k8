provider "helm" {
  install_tiller = true
  service_account = "tiller"
}

resource "helm_release" "postgresql" {
  name  = "postgresql"
  chart = "stable/postgresql"

     set {
        name  = "postgresqlDatabase"
        value = "gitlab"
    }
}

resource "helm_repository" "gitlab" {
    name = "gitlab"
    url  = "https://charts.gitlab.io/"
}

resource "helm_release" "redis" {
  name  = "redis"
  chart = "stable/redis"
  values = [
      "${file("redis.yaml")}"
    ]
}

resource "helm_release" "gitlab" {
  name       = "gitlab"
  repository = "${helm_repository.gitlab.metadata.0.name}"
  chart      = "gitlab"
  values = [
    "${file("gitlab.yaml")}"
  ]

  set {
    name  = "timeout"
    value = 600
  }
  depends_on = ["helm_release.redis","helm_release.postgresql"]
}