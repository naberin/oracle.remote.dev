
locals {
  availability_domain_name   = var.availability_domain_name != null ? var.availability_domain_name : data.oci_identity_availability_domains.ADs.availability_domains[0].name
  instance_shape             = var.instance_shape
  compute_flexible_shapes    = ["VM.Standard.E3.Flex","VM.Standard.E4.Flex"]
  is_flexible_instance_shape = contains(local.compute_flexible_shapes, local.instance_shape)
}

# region
variable region {}

# compartment
variable compartment_id {}

# compute
variable instance_ocpus {}
variable instance_shape_config_memory_in_gbs {}
variable generate_public_ssh_key {}
variable public_ssh_key {}

# images
variable instance_os {}
variable linux_os_version {}
variable instance_shape {}

# ad
variable availability_domain_name {}

# network
variable vcn_display_name {}
variable vcn_dns_label {}
variable vcn_cidr_blocks {}

# subnet
variable subnet_display_name {}
variable subnet_dns_label {}
variable subnet_cidr_block {}
variable subnet_availability_domain {}
variable subnet_prohibit_public_ip_on_vnic {}

# network - sl
variable web_sec_dn {}

# network - igw
variable internet_gateway_display_name {}

# network - rt
variable route_table_display_name {}