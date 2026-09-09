/*
********************
# Copyright (c) 2026 Oracle and/or its affiliates. All rights reserved.
# LiveLabs workshop provisioning variables.
********************
*/

# LiveLabs identity inputs used by the LiveStack Finance GenAI bootstrap.
# They remain optional so Resource Manager runs can use the system resource
# principal when these values are not injected.
variable "ociTenancyOcid" {
  type    = string
  default = ""
}

variable "ociUserOcid" {
  type    = string
  default = ""
}

variable "ociHomeRegionIdentifier" {
  type    = string
  default = ""
}

variable "home_tenancy_regions" {
  type    = map(string)
  default = {}
}

# This compatibility override is retained for the LiveLabs reservation
# injector. The standard compartment_ocid variable is the canonical input.
variable "ociCompartmentOcid" {
  type    = string
  default = ""
}

# This compatibility override is retained for the LiveLabs reservation
# injector. The standard region variable is the canonical input.
variable "ociRegionIdentifier" {
  type    = string
  default = ""
}

# Standard Resource Manager/provider variable names. The oci* variables above
# are retained for the LiveLabs reservation injector.
variable "region" {
  type        = string
  description = "Region where the LiveLabs Autonomous Database is provisioned."
  default     = "us-ashburn-1"

  validation {
    condition     = trimspace(var.region) != ""
    error_message = "Set region to the OCI region where the LiveLabs database will be created."
  }
}

variable "compartment_ocid" {
  type        = string
  description = "OCID of the compartment where the Autonomous Database is created."
  default     = ""
}

variable "resId" {
  type        = string
  description = "Optional short alphanumeric suffix used in the Autonomous Database name. If omitted, Terraform generates a unique suffix."
  default     = ""

  validation {
    condition     = trimspace(var.resId) == "" || (can(regex("^[A-Za-z0-9]+$", var.resId)) && length(var.resId) <= 11)
    error_message = "resId must be empty or a maximum 11-character alphanumeric value, for example F1A1."
  }
}

variable "ociGenAiRegion" {
  type    = string
  default = ""
}

# Optional existing tenancy-level dynamic group. Set this when the tenancy has
# reached its dynamic-group quota so the stack can reuse a pre-created group
# instead of creating another one. The group's matching rule must include the
# Autonomous Database created by this stack.
variable "ociDynamicGroupName" {
  type        = string
  description = "Existing tenancy dynamic group to reuse for Autonomous Database GenAI access. Leave empty to create one."
  default     = ""
}

# Additional standard LiveLabs inputs retained for reservation injection.
variable "ociUserPassword" {
  type      = string
  default   = ""
  sensitive = true
}

variable "ociPrivateSubnetOcid" {
  type    = string
  default = ""
}

variable "ociPublicSubnetOcid" {
  type    = string
  default = ""
}

variable "ociVcnOcid" {
  type    = string
  default = ""
}

variable "resUserPublicKey" {
  type    = string
  default = ""
}

variable "f1_user_name" {
  type    = string
  default = "F1_ANALYST"
}

variable "genai_profile_name" {
  type    = string
  default = "GENAI_PROFILE"
}

variable "embedding_profile_name" {
  type    = string
  default = "F1_EMBED_PROFILE"
}

# Password policy mirrors the LiveStack Finance baseline: the first character
# is alphabetic and the remaining characters contain upper/lower case letters
# and digits, without shell-special characters.
resource "random_string" "password_first_char" {
  length  = 1
  special = false
  lower   = true
  upper   = true
  numeric = false
}

resource "random_string" "password_remaining" {
  length      = 15
  special     = false
  lower       = true
  upper       = true
  numeric     = true
  min_numeric = 2
  min_lower   = 2
  min_upper   = 2
}

# LiveLabs normally supplies resId. Generate a fallback for Resource Manager
# stacks where that reservation variable is not injected.
resource "random_string" "db_name_suffix" {
  length      = 8
  special     = false
  lower       = true
  upper       = true
  numeric     = true
  min_numeric = 2
  min_lower   = 2
  min_upper   = 2
}

locals {
  admin_password = "${random_string.password_first_char.result}${random_string.password_remaining.result}"
  db_res_id      = trimspace(var.resId) != "" ? var.resId : "F1${random_string.db_name_suffix.result}"
  db_name        = "ATP${local.db_res_id}"
  db_service     = "${local.db_name}_high"

  oci_compartment_ocid            = trimspace(var.ociCompartmentOcid) != "" ? var.ociCompartmentOcid : var.compartment_ocid
  oci_region                      = trimspace(var.ociRegionIdentifier) != "" ? var.ociRegionIdentifier : var.region
  genai_region                    = trimspace(var.ociGenAiRegion) != "" ? var.ociGenAiRegion : local.oci_region
  home_region                     = trimspace(var.ociHomeRegionIdentifier) != "" ? var.ociHomeRegionIdentifier : try(var.home_tenancy_regions[var.ociTenancyOcid], local.oci_region)
  oci_tenancy_ocid                = trimspace(var.ociTenancyOcid)
  api_key_configured              = trimspace(var.ociTenancyOcid) != "" && trimspace(var.ociUserOcid) != ""
  existing_dynamic_group_name     = trimspace(var.ociDynamicGroupName)
  resource_principal_iam_required = !local.api_key_configured && local.oci_tenancy_ocid != ""
  resource_principal_iam_enabled  = local.resource_principal_iam_required && local.existing_dynamic_group_name == ""
  genai_credential_name           = local.api_key_configured ? "AI_CREDENTIAL" : "OCI$RESOURCE_PRINCIPAL"
}
