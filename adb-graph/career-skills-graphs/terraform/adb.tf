resource "oci_database_autonomous_database" "career_graphs" {
  admin_password              = local.admin_password
  compartment_id              = var.oci_compartment_ocid
  compute_model               = var.compute_model
  compute_count               = var.compute_count
  data_storage_size_in_tbs    = var.data_storage_size_in_tbs
  db_name                     = local.db_name
  db_version                  = var.db_version
  display_name                = local.display_name
  license_model               = var.license_model
  db_workload                 = var.db_workload
  is_free_tier                = var.is_free_tier
  is_mtls_connection_required = var.is_mtls_connection_required
  whitelisted_ips             = var.whitelisted_ips

}

data "oci_database_autonomous_database" "career_graphs" {
  autonomous_database_id = oci_database_autonomous_database.career_graphs.id
}

resource "oci_database_autonomous_database_wallet" "career_graphs" {
  autonomous_database_id = oci_database_autonomous_database.career_graphs.id
  password               = local.admin_password
  base64_encode_content  = true
  generate_type          = "SINGLE"
}

resource "local_file" "wallet" {
  content_base64  = oci_database_autonomous_database_wallet.career_graphs.content
  filename        = "${path.module}/atp_wallet.zip"
  file_permission = "0600"
}

resource "local_file" "create_user" {
  content = templatefile("${path.module}/db_scripts/create_user.sql.tmpl", {
    user_password = local.ghc_dev_password
  })
  filename        = "${path.module}/create_user.sql"
  file_permission = "0600"
}

resource "null_resource" "create_ghc_dev" {
  depends_on = [
    local_file.wallet,
    local_file.create_user
  ]

  triggers = {
    database_id           = oci_database_autonomous_database.career_graphs.id
    create_user_sha256    = filesha256(local_file.create_user.filename)
    admin_password_sha256 = sha256(local.admin_password)
  }

  provisioner "local-exec" {
    working_dir = path.module
    command = join(" ", [
      var.sql_command,
      "-cloudconfig", basename(local_file.wallet.filename),
      local.admin_logon,
      "@${local_file.create_user.filename}"
    ])
  }
}

resource "null_resource" "career_bootstrap" {
  count = local.career_bootstrap_path == "" ? 0 : 1

  depends_on = [
    null_resource.load_bundled_career_data,
    null_resource.create_ghc_dev,
    null_resource.configure_genai
  ]

  triggers = {
    database_id             = oci_database_autonomous_database.career_graphs.id
    script_sha256           = filesha256(local.career_bootstrap_path)
    ghc_dev_password_sha256 = sha256(local.ghc_dev_password)
  }

  provisioner "local-exec" {
    working_dir = path.module
    command = join(" ", [
      var.sql_command,
      "-cloudconfig", basename(local_file.wallet.filename),
      local.ghc_dev_logon,
      "@${local.career_bootstrap_path}"
    ])
  }
}

resource "null_resource" "load_bundled_career_data" {
  count = var.load_bundled_career_data ? 1 : 0

  depends_on = [
    null_resource.create_ghc_dev,
    null_resource.configure_genai
  ]

  triggers = {
    database_id               = oci_database_autonomous_database.career_graphs.id
    onet_archive_sha256       = filesha256("${path.module}/data/db_30_3_oracle.zip")
    abilities_workbook_sha256 = filesha256("${path.module}/data/Abilities.xlsx")
    abilities_loader_sha256   = filesha256("${path.module}/db_scripts/abilities_xlsx_load.sql")
    bundled_loader_sha256     = filesha256("${path.module}/db_scripts/load_bundled_data.sh")
    ghc_dev_password_sha256   = sha256(local.ghc_dev_password)
  }

  provisioner "local-exec" {
    working_dir = path.module
    command = join(" ", [
      "bash",
      "${path.module}/db_scripts/load_bundled_data.sh",
      basename(local_file.wallet.filename),
      local.ghc_dev_logon,
      var.sql_command
    ])
  }
}
