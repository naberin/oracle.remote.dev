
locals {
  availability_domain_name   = var.availability_domain_name != null ? var.availability_domain_name : data.oci_identity_availability_domains.ADs.availability_domains[0].name
  instance_shape             = var.instance_shape
  compute_flexible_shapes    = ["VM.Standard.E3.Flex","VM.Standard.E4.Flex"]
  is_flexible_instance_shape = contains(local.compute_flexible_shapes, local.instance_shape)
}