terraform {
  required_providers {
    vagrant = {
      source  = "bmatcuk/vagrant"
      version = "~> 4.1.0"
    }
  }
}

module "vbox-cluster" {  
  source = "./vbox-cluster"
}
