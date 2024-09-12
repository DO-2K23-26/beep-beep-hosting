resource "kubernetes_config_map" "services-config" {
  for_each = toset(var.namespaces)
  metadata {
    name      = var.config-map-name
    namespace = each.key
  }

  data = {
    DB_HOST        = "postgresql"
    DB_PORT        = "5432"
    DB_USER        = "postgres"
    DB_DATABASE    = var.postgresql_auth_database
    S3_REGION      = "us-east-1"
    S3_ENDPOINT    = "http://minio:9000"
    S3_BUCKET_NAME = var.minio_defaultBuckets
    REDIS_HOST     = "redis-master"
    REDIS_PORT     = "6379"
  }
}
