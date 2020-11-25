######################################
# Author        Leonardo Rizzi
# Email         leonardor@tjrs.jus.br
######################################

data "vsphere_datacenter" "dc" {
  name = "TJRS"
}

data "vsphere_datastore_cluster" "datastore_cluster" {
  name          = "DatastoreCluster_DEV-HML-TMT"
  datacenter_id = data.vsphere_datacenter.dc.id
}



data "vsphere_compute_cluster" "cluster" {
  name          = var.cluster_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  for_each      = var.network_interfaces
  name          = each.value.prefix_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "http" "ipam_prefix" {
  #for_each = { "a" = "10.203.100.0", "c" = "10.203.101.0" }
  for_each = var.network_interfaces
  url      = "${var.ipam_prefixes_uri}/?contains=${each.value.prefix_id}&mask_length=24"
  # Optional request headers
  request_headers = {
    Accept        = "application/json"
    Authorization = "Token 394c633a7c44e2f3f02adc3abb664dece27e854a"
  }
}

data "http" "ipam_available_address" {
  for_each = data.http.ipam_prefix
  url      = "${var.ipam_prefixes_uri}/${lookup(jsondecode(each.value.body).results[0], "id", null)}/available-ips/?limit=1"
  # Optional request headers
  request_headers = {
    Accept        = "application/json"
    Authorization = "Token 394c633a7c44e2f3f02adc3abb664dece27e854a"
  }
}

# locals {
#   addresses = [
#     for i, addr in data.http.ipam_available_address : {
#       i = {
#         ipv4_address = element(split("/", lookup(jsondecode(addr.body)[0], "address", null)), 0)
#         ipv4_netmask = tonumber(element(split("/", lookup(jsondecode(addr.body)[0], "address", null)), 1))
#       }
#     }
#   ]
# }


# data "http" "ipam_available_ip" {
#   url = "${var.ipam_prefixes_uri}/?contains=10.203.100.0&mask_length=24"
#   # Optional request headers
#   request_headers = {
#     Accept = "application/json"
#     Authorization = "Token 394c633a7c44e2f3f02adc3abb664dece27e854a"
#   }
# }


data "vsphere_virtual_machine" "template" {
  name          = var.template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

# TAGS
data "vsphere_tag_category" "consul" {
  name = "CONSUL"
}
data "vsphere_tag_category" "os" {
  name = "OS"
}
data "vsphere_tag" "linux" {
  name        = "LINUX"
  category_id = data.vsphere_tag_category.os.id
}

