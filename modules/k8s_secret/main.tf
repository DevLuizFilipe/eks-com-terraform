resource "kubernetes_secret" "kube_news_secret" {
  metadata {
    name      = var.secret_name_kube_news
    namespace = var.secret_namespace
  }
  data = {
    DB_DATABASE = "kube-news"
    DB_USERNAME = "luiz"
    DB_PASSWORD = "Teste123*"
    DB_HOST     = "postgres-service"
  }
}

resource "kubernetes_secret" "postgres_secret" {
  metadata {
    name      = var.secret_name_postgres
    namespace = var.secret_namespace
  }
  data = {
    POSTGRES_DB       = "kube-news"
    POSTGRES_USER     = "luiz"
    POSTGRES_PASSWORD = "Teste123*"
  }
}
