provider "google" {
credentials = file("service-account.json")
project     = "keen-clarity-309414"
region  =     "us-west1"
zone    =    "us-west1-a"
}

resource "google_container_cluster" "gke-cluster" {
  name               = "my-first-gke-cluster"
  network            = "default"
  location           =  "us-west1-a"
  initial_node_count = 1
}
