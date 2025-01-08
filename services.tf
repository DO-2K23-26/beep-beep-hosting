resource "helm_release" "postgresql" {
  for_each   = toset(var.namespaces)
  name       = "postgresql"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "postgresql"
  namespace  = each.key
  depends_on = [kubernetes_manifest.postgresql-secret]
  set {
    name  = "auth.existingSecret"
    value = "postgresql-secret"
  }

  set {
    name  = "auth.secretKeys.adminPasswordKey"
    value = "postgres-password"
  }

  set {
    name  = "auth.enabledPostgresUser"
    value = true
  }

  set {
    name  = "auth.database"
    value = var.postgresql_auth_database
  }

  set {
    name  = "primary.resourcesPreset"
    value = "large"
  }
}

resource "helm_release" "redis" {
  for_each   = toset(var.namespaces)
  name       = "redis"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "redis"
  namespace  = each.key
  depends_on = [kubernetes_manifest.redis-secret]
  set {
    name  = "auth.existingSecret"
    value = "redis-secret"
  }

  set {
    name  = "auth.existingSecretPasswordKey"
    value = "redis-password"
  }

  set {
    name  = "auth.enabled"
    value = true
  }
  set {
    name  = "architecture"
    value = "replication"
  }
}

resource "helm_release" "minio" {
  for_each   = toset(var.namespaces)
  name       = "minio"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "minio"
  namespace  = each.key
  depends_on = [kubernetes_manifest.minio-secret]
  set {
    name  = "auth.existingSecret"
    value = "minio-secret"
  }
  set {
    name  = "auth.rootUserSecretKey"
    value = "minio-user"
  }

  set {
    name  = "auth.rootPasswordSecretKey"
    value = "minio-password"
  }

  set {
    name  = "defaultBuckets"
    value = var.minio_defaultBuckets
  }
}
