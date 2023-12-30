# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  project = "domgerops"
  region  = "us-west1"
}

# https://www.terraform.io/language/settings/backends/gcs
# https://developer.hashicorp.com/terraform/language/providers/requirements
terraform {
  backend "gcs" {
    bucket = "domger_gke_tf_state_staging"
    prefix = "terraform/state"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

