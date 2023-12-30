# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router
# allows instance to access internet. allows kubernetes to obtain docker images
resource "google_compute_router" "router" {
  name    = "router"
  region  = "us-west1"
  network = google_compute_network.main.id
}

