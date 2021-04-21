provider "google" {
credentials = "${file("service-account.json")}"
project     = "keen-clarity-309414"
region  =     "us-west1"
zone    =    "us-west1-a"
}

