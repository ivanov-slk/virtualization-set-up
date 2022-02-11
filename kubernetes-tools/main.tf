terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubectl" {
  load_config_file = true
}


resource "kubectl_manifest" "example" {
  yaml_body = file("./kubernetes-tools/my_namespace.yaml")
}