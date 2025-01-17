resource "kubernetes_manifest" "postgresql-secret" {
  for_each   = toset(var.namespaces)
  depends_on = [kubernetes_namespace.namespaces]

  manifest = {
    "apiVersion" = "bitnami.com/v1alpha1"
    "kind"       = "SealedSecret"
    "metadata" = {
      "name"      = "postgresql-secret"
      "namespace" = each.key
    }
    "spec" = {
      "encryptedData" = {
        "postgres-password" = var.sealed-secrets[each.key].postgresql-secret
      }
      "template" = {
        "metadata" = {
          "name"      = "postgresql-secret"
          "namespace" = each.key
        }
        "type" = "Opaque"
      }
    }
  }
}

resource "kubernetes_manifest" "minio-secret" {
  for_each   = toset((var.namespaces))
  depends_on = [kubernetes_namespace.namespaces]

  manifest = {
    "apiVersion" = "bitnami.com/v1alpha1"
    "kind"       = "SealedSecret"
    "metadata" = {
      "name"      = "minio-secret"
      "namespace" = each.key
    }
    "spec" = {
      "encryptedData" = {
        "minio-password" = var.sealed-secrets[each.key].minio-secret-password
        "minio-user"     = var.sealed-secrets[each.key].minio-secret-user
      }
      "template" = {
        "metadata" = {
          "name"      = "minio-secret"
          "namespace" = each.key
        }
        "type" = "Opaque"
      }
    }
  }
}

resource "kubernetes_manifest" "redis-secret" {
  for_each   = toset((var.namespaces))
  depends_on = [kubernetes_namespace.namespaces]

  manifest = {
    "apiVersion" = "bitnami.com/v1alpha1"
    "kind"       = "SealedSecret"
    "metadata" = {
      "name"      = "redis-secret"
      "namespace" = each.key
    }
    "spec" = {
      "encryptedData" = {
        "redis-password" = var.sealed-secrets[each.key].redis-secret
      }
      "template" = {
        "metadata" = {
          "name"      = "redis-secret"
          "namespace" = each.key
        }
        "type" = "Opaque"
      }
    }
  }
}

resource "kubernetes_manifest" "harbor-secret" {
  for_each   = toset((var.namespaces))
  depends_on = [kubernetes_namespace.namespaces]

  manifest = {
    "apiVersion" = "bitnami.com/v1alpha1"
    "kind"       = "SealedSecret"
    "metadata" = {
      "name"      = "harbor-registry"
      "namespace" = each.key
    }
    "spec" = {
      "encryptedData" = {
        ".dockerconfigjson" = var.sealed-secrets[each.key].harbor-secret
      }
      "template" = {
        "metadata" = {
          "name"      = "harbor-registry"
          "namespace" = each.key
        }
        "type" = "kubernetes.io/dockerconfigjson"
      }
    }
  }

}
