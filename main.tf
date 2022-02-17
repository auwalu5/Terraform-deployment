
provider "google" {

credentials = file("/Users/myahaya/mdeey1291.json")
project = "mdeey1291"
region = "us-west2"

}


resource "google_compute_firewall" "default" {
  project     = "mdeey1291"
  name    = "i2c-to-nginx-gw-1"
  network = "default"

  allow { 
    protocol = "icmp"
  }
  source_ranges =["199.96.216.9/30"]
  target_tags = ["gw"]
}




resource "google_compute_firewall" "mgmt" {
  project     = "mdeey1291"
  name    = "i2c-to-nginx-gw-2"
  network = "mgmt"

  allow {
    protocol = "icmp"
  }
  source_ranges =["199.96.219.8/30"]
  target_tags = ["gw"]
}


data "google_compute_network" "mgmt_peer_network" {
  name    = "mgmt" #VPC name
  project = "mdeey1291"    #Project name
  #region = "us-west2"

}


resource "google_compute_network_peering" "mgmt-to-default" {
  name                 = "mgmt-to-default"
  network              = data.google_compute_network.mgmt_peer_network.id
  peer_network         = data.google_compute_network.default_peer_network.id
  export_custom_routes = "true"
  import_custom_routes = "true"
}


data "google_compute_network" "default_peer_network" {
  name    = "default" #VPC name
  project = "mdeey1291"    #Project name
  #region = "us-west2"

}

resource "google_compute_network_peering" "default-to-mgmt" {
  name                 = "default-to-mgmt"
  network              = data.google_compute_network.default_peer_network.id
  peer_network         = data.google_compute_network.mgmt_peer_network.id
  export_custom_routes = "true"
  import_custom_routes = "true"
}
