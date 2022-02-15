# Create Work VM
resource "oci_core_instance" compute {
  availability_domain = local.availability_domain_name
  compartment_id      = var.compartment_ocid
  display_name        = "work-vm"
  shape               = local.instance_shape

  dynamic "shape_config" {
    for_each = local.is_flexible_instance_shape ? [1] : []
    content {
      ocpus         = var.instance_ocpus
      memory_in_gbs = var.instance_shape_config_memory_in_gbs
    }
  }

  # create VNIC with compute
  create_vnic_details {
    subnet_id        = oci_core_subnet.subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = false
  }

  # specify VM image
  # source image is latest Oracle Linux image
  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.instanceOCID.images[0].id
  }

  # initialize the compute with cloud-init
  metadata = {
    ssh_authorized_keys = var.generate_public_ssh_key ? tls_private_key.public_private_key_pair.public_key_openssh : join("\n", [var.public_ssh_key, tls_private_key.public_private_key_pair.public_key_openssh])
    user_data = base64encode(templatefile("./scripts/init.yaml", {}))
  }
}

# Retrieve created VNIC with Compute
data "oci_core_vnic_attachments" attached_vnic {
  compartment_id      = var.compartment_ocid
  availability_domain = local.availability_domain_name
  instance_id         = oci_core_instance.compute.id
}

# Reference VNIC
data "oci_core_vnic" compute_vnic {
  vnic_id = data.oci_core_vnic_attachments.attached_vnic.vnic_attachments[0]["vnic_id"]
}

# Retrieve Private IP from VNIC
data "oci_core_private_ips" compute_private_ip {
  vnic_id = data.oci_core_vnic.compute_vnic.id
}

# Create Reserved Public IP with the above
  resource "oci_core_public_ip" compute_public_ip {
  compartment_id = var.compartment_ocid
  display_name   = "work-vm-public-ip"
  lifetime       = "RESERVED"
  private_ip_id  = data.oci_core_private_ips.compute_private_ip.private_ips[0]["id"]
}
