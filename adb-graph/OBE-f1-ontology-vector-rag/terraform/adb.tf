#*************************************
#       Autonomous AI Lakehouse
#*************************************

resource "oci_database_autonomous_database" "f1_lakehouse" {
  admin_password           = local.admin_password
  compartment_id           = local.oci_compartment_ocid
  compute_model            = "ECPU"
  compute_count            = 2
  data_storage_size_in_tbs = 1
  db_name                  = local.db_name
  db_version               = "26ai"
  display_name             = "F1 Ontology Graph ${local.db_res_id}"
  license_model            = "BRING_YOUR_OWN_LICENSE"

  # DW is the Autonomous AI Lakehouse workload value supported by the OCI
  # provider during the LiveLabs reservation period.
  db_workload                 = "DW"
  is_free_tier                = false
  is_mtls_connection_required = false

  # The workshop connects through browser-based database tools and does not
  # provision a VCN or private endpoint.
  whitelisted_ips = ["0.0.0.0/0"]

  lifecycle {
    precondition {
      condition     = trimspace(local.oci_compartment_ocid) != ""
      error_message = "Set ociCompartmentOcid or compartment_ocid in the Resource Manager stack variables."
    }

    precondition {
      condition     = local.api_key_configured || trimspace(local.oci_tenancy_ocid) != ""
      error_message = "Set ociTenancyOcid for resource-principal IAM bootstrap, or provide both ociTenancyOcid and ociUserOcid for LiveStack Finance API-key authentication. If the tenancy dynamic-group quota is full, also set ociDynamicGroupName to an existing compatible dynamic group."
    }
  }
}

resource "oci_database_autonomous_database_wallet" "f1_wallet" {
  autonomous_database_id = oci_database_autonomous_database.f1_lakehouse.id
  password               = local.admin_password

  base64_encode_content = true
  generate_type         = "SINGLE"
}

resource "local_file" "f1_wallet_file" {
  content_base64  = oci_database_autonomous_database_wallet.f1_wallet.content
  filename        = "${path.module}/atp_wallet.zip"
  file_permission = "0600"
}

resource "local_file" "create_f1_user" {
  depends_on      = [local_file.f1_wallet_file]
  filename        = "${path.module}/create_f1_user.sql"
  file_permission = "0600"

  content = templatefile("${path.module}/create_f1_user.sql.tmpl", {
    f1_user_name       = upper(var.f1_user_name)
    user_password      = local.admin_password
    genai_host         = "inference.generativeai.${local.genai_region}.oci.oraclecloud.com"
    api_key_configured = local.api_key_configured
  })
}

resource "null_resource" "create_f1_user" {
  triggers = {
    autonomous_database_id = oci_database_autonomous_database.f1_lakehouse.id
    f1_user_name           = upper(var.f1_user_name)
  }

  provisioner "local-exec" {
    working_dir = path.module
    command     = "sql -cloudconfig ${local_file.f1_wallet_file.filename} admin/${local.admin_password}@${local.db_service} @${local_file.create_f1_user.filename}"
  }

  depends_on = [
    local_file.create_f1_user,
    oci_identity_policy.f1_adb_genai
  ]
}

resource "local_file" "create_f1_graph" {
  depends_on      = [local_file.f1_wallet_file]
  filename        = "${path.module}/create_f1_graph.sql"
  file_permission = "0600"

  content = templatefile("${path.module}/create_f1_graph.sql.tmpl", {
    f1_user_name = upper(var.f1_user_name)
  })
}

resource "null_resource" "create_f1_graph" {
  triggers = {
    autonomous_database_id = oci_database_autonomous_database.f1_lakehouse.id
    f1_user_name           = upper(var.f1_user_name)
    network_name           = "F1_NET"
    graph_name             = "F1_2026_GRAPH"
  }

  provisioner "local-exec" {
    working_dir = path.module
    command     = "sql -cloudconfig ${local_file.f1_wallet_file.filename} ${upper(var.f1_user_name)}/${local.admin_password}@${local.db_service} @${local_file.create_f1_graph.filename}"
  }

  depends_on = [
    null_resource.create_f1_user,
    local_file.create_f1_graph
  ]
}

#*************************************
#             Outputs
#*************************************

output "adb_admin_password" {
  value     = local.admin_password
  sensitive = true
}

output "atp_admin_password" {
  value     = local.admin_password
  sensitive = true
}

output "atp_name" {
  value = [local.db_name]
}

output "f1_analyst_user" {
  value = upper(var.f1_user_name)
}

output "f1_analyst_password" {
  value     = local.admin_password
  sensitive = true
}

output "sql_url" {
  value = [oci_database_autonomous_database.f1_lakehouse.connection_urls[0].sql_dev_web_url]
}

output "graph_studio_url" {
  value = [oci_database_autonomous_database.f1_lakehouse.connection_urls[0].graph_studio_url]
}

output "apex_url" {
  value = [oci_database_autonomous_database.f1_lakehouse.connection_urls[0].apex_url]
}
