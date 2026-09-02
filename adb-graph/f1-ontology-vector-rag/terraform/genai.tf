# Use the LiveStack Finance pattern when LiveLabs supplies the tenancy and
# user OCIDs: Terraform creates an OCI signing key and the SQL bootstrap stores
# it as AI_CREDENTIAL. The resource-principal path remains available for
# Resource Manager runs that intentionally omit those identity inputs.
resource "tls_private_key" "api" {
  count     = local.api_key_configured ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "oci_identity_api_key" "api" {
  count     = local.api_key_configured ? 1 : 0
  provider  = oci.home
  user_id   = var.ociUserOcid
  key_value = tls_private_key.api[0].public_key_pem
}

resource "local_file" "genai_connection" {
  depends_on      = [oci_identity_api_key.api]
  filename        = "${path.module}/genai_connection.sql"
  file_permission = "0600"

  content = templatefile("${path.module}/genai_connection.sql.tmpl", {
    api_key_configured     = local.api_key_configured
    private_key_pem        = local.api_key_configured ? tls_private_key.api[0].private_key_pem : ""
    fingerprint            = local.api_key_configured ? oci_identity_api_key.api[0].fingerprint : ""
    oci_tenancy_ocid       = var.ociTenancyOcid
    oci_user_ocid          = var.ociUserOcid
    oci_compartment_ocid   = local.oci_compartment_ocid
    oci_genai_region       = local.genai_region
    genai_credential_name  = local.genai_credential_name
    genai_profile_name     = var.genai_profile_name
    embedding_profile_name = var.embedding_profile_name
  })
}

resource "null_resource" "configure_genai_profiles" {
  triggers = {
    autonomous_database_id  = oci_database_autonomous_database.f1_lakehouse.id
    f1_user_name            = upper(var.f1_user_name)
    genai_profile_name      = var.genai_profile_name
    embedding_profile_name  = var.embedding_profile_name
    genai_credential_name   = local.genai_credential_name
    genai_connection_sha256 = local_file.genai_connection.content_sha256
  }

  provisioner "local-exec" {
    working_dir = path.module
    command     = "sql -cloudconfig ${local_file.f1_wallet_file.filename} ${upper(var.f1_user_name)}/${local.admin_password}@${local.db_service} @${local_file.genai_connection.filename}"
  }

  depends_on = [
    null_resource.create_f1_graph,
    local_file.genai_connection,
    oci_identity_policy.f1_adb_genai
  ]
}

output "genai_profile_name" {
  value = var.genai_profile_name
}

output "embedding_profile_name" {
  value = var.embedding_profile_name
}

output "genai_credential_name" {
  value = local.genai_credential_name
}
