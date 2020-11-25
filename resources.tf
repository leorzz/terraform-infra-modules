######################################
# Author        Leonardo Rizzi
# Email         leonardor@tjrs.jus.br
######################################

resource "vsphere_tag" "service" {
  name        = lower(var.service_group)
  category_id = data.vsphere_tag_category.consul.id
  description = var.service_description
}

resource "vsphere_folder" "folder" {
  path          = "/SPRINGBOOT/DEV/${lower(var.service_group)}"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
  tags = [
    vsphere_tag.service.id,
    data.vsphere_tag.linux.id
  ]
}

resource "vsphere_virtual_machine" "virtual_machines" {
  #count            = length(var.esxi_hosts)
  count                = var.virtual_machine_instances
  name                 = lower("${var.service_group}-${var.environment}-${format("%02s", count.index + 1)}.${var.virtual_machine_domain}")
  resource_pool_id     = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_cluster_id = data.vsphere_datastore_cluster.datastore_cluster.id
  folder               = "/SPRINGBOOT/DEV/${lower(var.service_group)}"



  num_cpus  = var.virtual_machine_num_cpus
  memory    = var.virtual_machine_memory_mb
  guest_id  = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type


  dynamic "network_interface" {
    for_each = data.vsphere_network.network
    content {
      network_id   = network_interface.value.id
      adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
    }
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  disk {
    label            = "disk1"
    size             = 2
    unit_number      = 1
    thin_provisioned = true
  }

  # lifecycle {
  #   ignore_changes = [disk]
  # }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      linux_options {
        host_name = lower("${var.service_group}-${var.environment}-${format("%02s", count.index + 1)}")
        domain    = var.virtual_machine_domain
      }

      dynamic "network_interface" {
        for_each = data.http.ipam_available_address
        content {
          ipv4_address = element(split("/", lookup(jsondecode(network_interface.value.body)[0], "address", null)), 0)
          ipv4_netmask = tonumber(element(split("/", lookup(jsondecode(network_interface.value.body)[0], "address", null)), 1))

        }
      }
      ipv4_gateway    = var.virtual_machine_gateway
      dns_suffix_list = [var.virtual_machine_domain]
      dns_server_list = var.virtual_machine_dns_servers
    }
  }

  tags = [
    vsphere_tag.service.id,
    data.vsphere_tag.linux.id
  ]
}
