terraform {

  required_providers {
    oci = {
      source = "hashicorp/oci"
    }

    random = {
      source = "hashicorp/random"
    }
  }

  required_version = ">= 0.14"
}

provider "oci" {
  region = var.region
}