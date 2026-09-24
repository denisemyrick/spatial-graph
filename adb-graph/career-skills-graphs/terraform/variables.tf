variable "oci_tenancy_ocid" {
  description = "OCID of the tenancy that owns the OCI API key and target database."
  type        = string
}

variable "oci_user_ocid" {
  description = "OCID of the OCI user whose API key Terraform creates for GenAI."
  type        = string
}

variable "oci_compartment_ocid" {
  description = "OCID of the compartment in which to create the Autonomous AI Database."
  type        = string
}

variable "oci_region_identifier" {
  description = "OCI region for the Autonomous AI Database."
  type        = string
}

variable "oci_home_region" {
  description = "Optional home region for the OCI Identity API key. Defaults to the database region."
  type        = string
  default     = null
  nullable    = true
}

variable "res_id" {
  description = "Short unique suffix used in the database and display names."
  type        = string
  default     = "GHC"

  validation {
    condition     = can(regex("^[A-Za-z0-9]+$", var.res_id)) && length(var.res_id) >= 1 && length(var.res_id) <= 12
    error_message = "res_id must be 1-12 alphanumeric characters."
  }
}

variable "db_name_prefix" {
  description = "Prefix for the Autonomous Database name."
  type        = string
  default     = "ATP"
}

variable "display_name_prefix" {
  description = "Prefix for the Autonomous Database display name."
  type        = string
  default     = "GHC-Career-Graphs-"
}

variable "adb_admin_password" {
  description = "Optional 12-30 character ADMIN password. If null, Terraform generates an alphanumeric password."
  type        = string
  default     = null
  nullable    = true
  sensitive   = true

  validation {
    condition     = var.adb_admin_password == null || can(regex("^[^\"]{12,30}$", var.adb_admin_password))
    error_message = "adb_admin_password must be 12-30 characters and cannot contain a double quote."
  }
}

variable "ghc_dev_password" {
  description = "Optional 12-30 character GHC_DEV password. If null, Terraform generates an alphanumeric password."
  type        = string
  default     = null
  nullable    = true
  sensitive   = true

  validation {
    condition     = var.ghc_dev_password == null || can(regex("^[^\"]{12,30}$", var.ghc_dev_password))
    error_message = "ghc_dev_password must be 12-30 characters and cannot contain a double quote."
  }
}

variable "compute_model" {
  description = "Autonomous Database compute model."
  type        = string
  default     = "ECPU"
}

variable "compute_count" {
  description = "ECPU count for the Autonomous Database."
  type        = number
  default     = 2
}

variable "data_storage_size_in_tbs" {
  description = "Base data storage size in TB. Ignored for Always Free databases."
  type        = number
  default     = 1
}

variable "db_version" {
  description = "Autonomous AI Database version."
  type        = string
  default     = "26ai"
}

variable "db_workload" {
  description = "Autonomous AI Database workload. OLTP keeps APEX available for this workshop."
  type        = string
  default     = "OLTP"
}

variable "license_model" {
  description = "BRING_YOUR_OWN_LICENSE or LICENSE_INCLUDED, subject to tenancy entitlement."
  type        = string
  default     = "BRING_YOUR_OWN_LICENSE"
}

variable "is_free_tier" {
  description = "Whether to request an Always Free database."
  type        = bool
  default     = false
}

variable "is_mtls_connection_required" {
  description = "Require mTLS for database connections. False permits password authentication with the generated wallet."
  type        = bool
  default     = false
}

variable "whitelisted_ips" {
  description = "CIDR allow-list for database access. The default is workshop-friendly; restrict it for non-workshop use."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "genai_region" {
  description = "OCI Generative AI region used by the DBMS_CLOUD_AI profile. Defaults to the database region."
  type        = string
  default     = null
  nullable    = true
}

variable "genai_profile_name" {
  description = "DBMS_CLOUD_AI profile name consumed by the workshop."
  type        = string
  default     = "GHC_CAREER_AI"
}

variable "genai_credential_name" {
  description = "DBMS_CLOUD credential name used by the GenAI profile."
  type        = string
  default     = "AI_CREDENTIAL"
}

variable "sql_command" {
  description = "SQLcl executable available on the machine running terraform apply."
  type        = string
  default     = "sql"
}

variable "career_bootstrap_sql" {
  description = "Optional relative or absolute path to a consolidated career schema/data/graph/package SQL script."
  type        = string
  default     = ""
}

variable "load_bundled_career_data" {
  description = "Load the bundled O*NET 30.3 SQL archive and Abilities.xlsx extract into GHC_DEV."
  type        = bool
  default     = true
}
