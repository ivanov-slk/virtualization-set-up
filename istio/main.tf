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

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

data "external" "get_latest_istio_version" {
  program = ["bash", "./istio/get-latest-istio.sh"]
}

# Ugly...
resource "null_resource" "download_istio_charts" {
  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "mkdir -p ./istio/istio-charts && cd ./istio/istio-charts && curl -L https://istio.io/downloadIstio | sh - && cd -"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ./istio/istio-charts"
  }
}
