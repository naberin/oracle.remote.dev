# List all Oracle Linux compute instance images
data "oci_core_images" instanceOCID {
  compartment_id           = var.compartment_ocid
  operating_system         = var.instance_os
  operating_system_version = var.linux_os_version
  shape                    = var.instance_shape

  filter {
    name   = "display_name"
    values = ["^.*Oracle[^G]*$"]
    regex  = true
  }
}

# Find all Availability Domains available in the tenancy
data "oci_identity_availability_domains" ADs {
  compartment_id = var.compartment_ocid
}
