resource "kubernetes_namespace" "namespaces" {
  for_each = toset(var.namespaces)
  metadata {
    name = each.key
  }

}
