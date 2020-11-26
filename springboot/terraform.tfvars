
vcenter_server      = "vcenter-01.tj.rs"
vcenter_user        = "tjrs\\leonardor"
vcenter_password    = "cangacv%6"

service_group       = "Newteste"
service_description = "yourdescription bla bla"


ipam_prefixes_uri   = "http://infra-prd-01.tjrs.gov.br:8080/api/ipam/prefixes"

datacenter   = "TJRS"
environment  = "DEV"
cluster_name = "DEV-HML-TMT"
# resource_pool = "DEV-HML-TMT/Resources"
# datastore_name = "ESXI_HML_HUAWEI_5"

template_name                   = "TF_CentOS_7.6.1810Core_10GB"
virtual_machine_domain          = "tjrs.gov.br"

virtual_machine_dns_servers = [
  "10.200.0.181",
  "10.200.0.182"
]

virtual_machine_instance_count = 2
virtual_machine_num_cpus = 2
virtual_machine_memory_mb = 1024

network_interfaces = {
  "nic0" = {
    prefix_name = "AmbienteDesenv"
    prefix_id = "10.203.100.0"
  },
  "nic1" = {
    prefix_name = "AmbienteDesenv2"
    prefix_id = "10.203.99.0"
  }
}
virtual_machine_gateway         = "10.203.99.1"
