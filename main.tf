terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
      version = "~> 4.1.0"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.4.1"

    }

    external = {
      source  = "hashicorp/external"
      version = ">= 2.2.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.4"
    }
  }
}

provider "kubectl" {
  load_config_file = true
}

provider "helm" {
  debug = true
  kubernetes {
    config_path = "~/.kube/config"
  }
}

module "packer-vmis" {
  source                = "./packer-vmis"
  virtual_machine_image = var.virtual_machine_image
  private_key_path      = var.private_key_path
}

module "kubernetes-cluster" {
  source                = "./kubernetes-cluster"
  virtual_machine_image = var.virtual_machine_image
  private_key_path      = var.private_key_path
  ip_base               = var.ip_base
  cluster_name          = var.cluster_name
  master_count          = var.master_count
  master_cpus           = var.master_cpus
  master_memory         = var.master_memory
  worker_count          = var.worker_count
  worker_cpus           = var.worker_cpus
  worker_memory         = var.worker_memory

  # depends_on = [module.packer-vmis]
}

resource "time_sleep" "wait-for-pods-to-initialize" {
  depends_on = [module.kubernetes-cluster]

  create_duration = "1m"
}

module "metallb" {
  source = "./metallb-configuration"

  depends_on = [module.kubernetes-cluster, time_sleep.wait-for-pods-to-initialize]
}

module "linkerd" {
  source = "./linkerd-configuration"

  depends_on = [module.metallb]
}

module "kubernetes-dashboard" {
  source = "./kubernetes-dashboard"

  depends_on = [module.linkerd]
}



