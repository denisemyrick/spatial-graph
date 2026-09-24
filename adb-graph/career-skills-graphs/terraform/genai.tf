resource "tls_private_key" "genai_api" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "oci_identity_api_key" "genai_api" {
  provider  = oci.home
  user_id   = var.oci_user_ocid
  key_value = tls_private_key.genai_api.public_key_pem
}

resource "local_file" "genai_connection" {
  depends_on = [oci_identity_api_key.genai_api]

  content = templatefile("${path.module}/db_scripts/genai_connection.sql.tmpl", {
    private_key_pem      = tls_private_key.genai_api.private_key_pem
    fingerprint          = oci_identity_api_key.genai_api.fingerprint
    oci_user_ocid        = var.oci_user_ocid
    oci_tenancy_ocid     = var.oci_tenancy_ocid
    oci_compartment_ocid = var.oci_compartment_ocid
    genai_region         = local.genai_region
    profile_name         = var.genai_profile_name
    credential_name      = var.genai_credential_name
  })
  filename        = "${path.module}/genai_connection.sql"
  file_permission = "0600"
}

resource "null_resource" "configure_genai" {
  depends_on = [
    null_resource.create_ghc_dev,
    local_file.genai_connection
  ]

  triggers = {
    database_id             = oci_database_autonomous_database.career_graphs.id
    genai_sql_sha256        = filesha256(local_file.genai_connection.filename)
    ghc_dev_password_sha256 = sha256(local.ghc_dev_password)
  }

  provisioner "local-exec" {
    working_dir = path.module
    command = join(" ", [
      var.sql_command,
      "-cloudconfig", basename(local_file.wallet.filename),
      local.ghc_dev_logon,
      "@${local_file.genai_connection.filename}"
    ])
  }
}
