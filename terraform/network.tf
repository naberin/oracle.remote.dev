
# main VCN
resource "oci_core_vcn" vcn {
    compartment_id = var.compartment_id
    display_name = var.vcn_display_name
    dns_label = var.vcn_dns_label
    cidr_blocks = var.vcn_cidr_blocks

    defined_tags = null
    freeform_tags = null

    lifecycle {
        ignore_changes = [
            # Ignore changes to tags, e.g. because a management agent
            # updates these based on some ruleset managed elsewhere.
            defined_tags, freeform_tags
        ]
    }
}

# security list
# todo: tighten security
resource "oci_core_security_list" web_sec_list {
    #Required
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.vcn.id
    display_name = var.web_sec_dn

    #Optional
    defined_tags = null
    freeform_tags = null

    ingress_security_rules {
        protocol = "1"  # ICMP
        source = "0.0.0.0/0"
        description = "Ping"

        stateless = false
        icmp_options {
            type = "8"
        }
    }

    ingress_security_rules {
        protocol = "6"  # TCP
        source = "0.0.0.0/0"
        description = "HTTP Request"

        stateless = true
        tcp_options {
            max = "80"
            min = "80"
        }
    }

    ingress_security_rules {
        protocol = "6"  # TCP
        source = "0.0.0.0/0"
        description = "SSH"

        stateless = false
        tcp_options {
            max = "22"
            min = "22"
        }
    }

    ingress_security_rules {
        protocol = "6"  # TCP
        source = "0.0.0.0/0"
        description = "Custom API Port"

        stateless = false
        tcp_options {
            max = "5000"
            min = "5000"
        }
    }
}

# internet gateway
resource "oci_core_internet_gateway" igw {

    compartment_id = var.compartment_id
    display_name = var.internet_gateway_display_name
    vcn_id = oci_core_vcn.vcn.id
    enabled = true

    defined_tags = null
    freeform_tags = null
}

# route table using igw resource above
resource "oci_core_route_table" rt {
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.vcn.id
    display_name = var.route_table_display_name

    route_rules {
        network_entity_id = oci_core_internet_gateway.igw.id

        description = "Route Table connecting to IGW"
        destination = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }

    defined_tags = null
    freeform_tags = null
}


# public single subnet
# todo: use bastion and load balancer with private subnet
resource "oci_core_subnet" subnet {

    cidr_block = var.subnet_cidr_block
    compartment_id = var.compartment_id
    vcn_id = oci_core_vcn.vcn.id

    display_name = var.subnet_display_name
    dns_label = var.subnet_dns_label

    availability_domain = var.subnet_availability_domain
    prohibit_public_ip_on_vnic = var.subnet_prohibit_public_ip_on_vnic
    route_table_id = oci_core_route_table.rt.id
    security_list_ids = oci_core_security_list.web_sec_list.id

    defined_tags = null
    freeform_tags = null

    lifecycle {
        ignore_changes = [
            # Ignore changes to tags, e.g. because a management agent
            # updates these based on some ruleset managed elsewhere.
            defined_tags, freeform_tags
        ]
    }
}

