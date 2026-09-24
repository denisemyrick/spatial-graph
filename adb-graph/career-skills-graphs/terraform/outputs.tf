output "adb_ocid" {
  description = "OCID of the provisioned Autonomous AI Database."
  value       = oci_database_autonomous_database.career_graphs.id
}

output "adb_name" {
  description = "Database name used by the provisioned Autonomous AI Database."
  value       = local.db_name
}

output "adb_admin_password" {
  description = "ADMIN password. Store it in an approved secret manager."
  value       = local.admin_password
  sensitive   = true
}

output "ghc_dev_user" {
  value = "GHC_DEV"
}

output "ghc_dev_password" {
  description = "GHC_DEV password. Store it in an approved secret manager."
  value       = local.ghc_dev_password
  sensitive   = true
}

output "genai_profile_name" {
  value = var.genai_profile_name
}

output "apex_url" {
  value = data.oci_database_autonomous_database.career_graphs.connection_urls[0].apex_url
}

output "sql_dev_web_url" {
  value = data.oci_database_autonomous_database.career_graphs.connection_urls[0].sql_dev_web_url
}

output "ords_url" {
  value = data.oci_database_autonomous_database.career_graphs.connection_urls[0].ords_url
}

output "graphql_url" {
  description = "ORDS GraphQL endpoint base for GHC_DEV. REST-enable individual tables or views before querying them."
  value       = "${trimsuffix(data.oci_database_autonomous_database.career_graphs.connection_urls[0].ords_url, "/")}/ghc_dev/_/graphql"
}

output "graph_studio_url" {
  value = data.oci_database_autonomous_database.career_graphs.connection_urls[0].graph_studio_url
}

output "wallet_file" {
  description = "Local wallet path. This file is ignored by the included .gitignore."
  value       = local_file.wallet.filename
}

output "apex_export_file" {
  value = "${path.module}/apex/f100.sql"
}
