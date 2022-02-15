
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
variable instance_ocpus {
  default       = 1
}
variable instance_shape_config_memory_in_gbs {
  default       = 16
}
variable generate_public_ssh_key {
  default       = true
}
variable public_ssh_key {
  default       = ""
}

# images
variable instance_os {
  description   = "Operating system"
  default       = "Oracle Linux"
}
variable linux_os_version {
  description   = "Operating system version"
  default       = "7.9"
}
variable instance_shape {
  default       = "VM.Standard.E3.Flex"
}

# ad
variable availability_domain_name {
  default       = null
}

# network
variable vcn_display_name {
  default       = "workvm-vcn"
}
variable vcn_dns_label {
  default       = "workvmvcn"
}
variable vcn_cidr_blocks {
  description   = "VCN's CIDR IP Block"
  default       = "10.0.0.0/16"
}

# subnet
variable subnet_display_name {
  default       = "workvm-subnet"
}
variable subnet_dns_label {
  default       = "workvmsubnet"
}
variable subnet_prohibit_public_ip_on_vnic {
  default       = false
}

# network - sl
variable web_sec_dn {
  description   = "Open Security List"
  default       = "workvm-open-sl"
}

# network - igw
variable internet_gateway_display_name {
  default       = "workvm-open-igw"
}

# network - rt
variable route_table_display_name {
  default       = "workvm-open-rt"
}