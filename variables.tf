######################################
# Author        Leonardo Rizzi
# Email         leonardor@tjrs.jus.br
######################################

variable "service_group" {
  type        = string
  description = "Service name or app name."
  #   default     = ""
  validation {

    condition     = regex("[a-zA-Z]+", var.service_group) == var.service_group
    error_message = "Error: Use 'terraform apply -var=\"service_group=<your_service>\" -var=\"service_description=<your_description>\"' The service_group need match [a-zA-Z]."
  }
}

variable "service_description" {
  type        = string
  description = "Service name description."
  #   default     = ""
  validation {
    condition     = var.service_description != ""
    error_message = "Error: Use 'terraform apply -var=\"service_group=<your_service>\" -var=\"service_description=<your_description>\"'."
  }
}


// The datacenter the resources will be created in.
variable "datacenter" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "environment" {
  type = string
}


# // The name of the datastore to create.
# variable "datastore_name" {
#   type = string
# }

variable "ipam_prefixes_uri" {
  type = string
}


variable "virtual_machine_instances" {
  type = number
}
variable "virtual_machine_num_cpus" {
  type = number
}
variable "virtual_machine_memory_mb" {
  type = number
}


// The name of the network interfaces to bind the DVS to on each host. These
// interfaces need to be available across all hosts defined in esxi_hosts.
variable "network_interfaces" {
  type = map(object({
    prefix_name = string
    prefix_id   = string

  }))
}

// The name of the template to use when cloning.
variable "template_name" {
  type = string
}


// The domain name to set up each virtual machine as.
variable "virtual_machine_domain" {
  type = string
}



// The default gateway for the network the virtual machines reside in.
variable "virtual_machine_gateway" {
  type = string
}

// The DNS servers for the network the virtual machines reside in.
variable "virtual_machine_dns_servers" {
  type    = list(string)
  default = ["10.200.0.181", "10.200.0.182"]
}
