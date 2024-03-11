terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.16.0"
    }
  }
}
variable "namespace" {
  description = "The namespace to deploy PostgreSQL in"
  type        = string
}

variable "password" {
  description = "The password for the PostgreSQL database"
  type        = string
}

provider "kubernetes" {
  host = "https://kubernetes.default.svc.cluster.local"

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "sh"
    args        = ["-c", "cat /var/run/secrets/kubernetes.io/serviceaccount/token"]
  }

  cluster_ca_certificate = file("/var/run/secrets/kubernetes.io/serviceaccount/ca.crt")
}

resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "postgres"
    namespace = var.namespace
  }

  spec {
    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          image = "postgres:latest"
          name  = "postgres"

          env {
            name  = "POSTGRES_PASSWORD"
            value = var.password
          }

          port {
            container_port = 5432
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name      = "postgres"
    namespace = var.namespace
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      port        = 5432
      target_port = 5432
    }
  }
}
