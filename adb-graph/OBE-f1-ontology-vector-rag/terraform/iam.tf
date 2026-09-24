# Resource-principal access for the ADB is created only when the LiveStack
# Finance API-key inputs are not supplied. Dynamic groups are tenancy-level
# resources, so all IAM objects use the home-region provider. The workshop
# loads public read-only PAR URLs, so it does not need Object Storage IAM
# grants.
data "oci_identity_dynamic_groups" "f1_existing" {
  count          = local.existing_dynamic_group_name != "" && local.resource_principal_iam_required ? 1 : 0
  provider       = oci.home
  compartment_id = local.oci_tenancy_ocid
  name           = local.existing_dynamic_group_name
}

resource "oci_identity_dynamic_group" "f1_adb" {
  count          = local.resource_principal_iam_enabled ? 1 : 0
  provider       = oci.home
  compartment_id = local.oci_tenancy_ocid
  name           = "f1-ontology-${lower(local.db_res_id)}-adb"
  description    = "Resource principal for the F1 ontology vector RAG Autonomous Database"
  matching_rule  = "resource.id = '${oci_database_autonomous_database.f1_lakehouse.id}'"
}

locals {
  f1_dynamic_group_name = local.existing_dynamic_group_name != "" ? try(data.oci_identity_dynamic_groups.f1_existing[0].dynamic_groups[0].name, "") : (local.resource_principal_iam_enabled ? oci_identity_dynamic_group.f1_adb[0].name : "")
}

resource "oci_identity_policy" "f1_adb_genai" {
  count          = local.resource_principal_iam_required ? 1 : 0
  provider       = oci.home
  compartment_id = local.oci_tenancy_ocid
  name           = "f1-ontology-${lower(local.db_res_id)}-genai"
  description    = "Least-privilege access for the F1 ontology vector RAG resource principal"

  lifecycle {
    precondition {
      condition     = trimspace(local.f1_dynamic_group_name) != ""
      error_message = "ociDynamicGroupName did not resolve to an existing tenancy dynamic group. Provide a valid existing group or leave it empty to create one."
    }
  }

  statements = [
    "Allow dynamic-group ${local.f1_dynamic_group_name} to use generative-ai-family in compartment id ${local.oci_compartment_ocid}"
  ]
}

output "genai_dynamic_group_name" {
  value = local.resource_principal_iam_required ? local.f1_dynamic_group_name : null
}

output "genai_iam_policy_name" {
  value = local.resource_principal_iam_required ? oci_identity_policy.f1_adb_genai[0].name : null
}
