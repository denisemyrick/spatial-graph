terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
    oci = {
      source  = "oracle/oci"
      version = ">= 8.5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "oci" {
  region = var.oci_region_identifier
}

provider "oci" {
  alias  = "home"
  region = coalesce(var.oci_home_region, var.oci_region_identifier)
}

resource "random_password" "adb_admin" {
  length      = 24
  special     = false
  upper       = true
  lower       = true
  numeric     = true
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
}

resource "random_password" "ghc_dev" {
  length      = 24
  special     = false
  upper       = true
  lower       = true
  numeric     = true
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
}

locals {
  admin_password   = coalesce(var.adb_admin_password, random_password.adb_admin.result)
  ghc_dev_password = coalesce(var.ghc_dev_password, random_password.ghc_dev.result)

  db_name      = "${var.db_name_prefix}${var.res_id}"
  display_name = "${var.display_name_prefix}${var.res_id}"
  high_service = "${local.db_name}_high"
  genai_region = coalesce(var.genai_region, var.oci_region_identifier)

  # SQLcl accepts quoted passwords in a logon string. The outer single quotes
  # keep shell metacharacters from being expanded by local-exec.
  admin_logon   = format("'admin/\"%s\"@%s'", replace(local.admin_password, "'", "'\\''"), local.high_service)
  ghc_dev_logon = format("'GHC_DEV/\"%s\"@%s'", replace(local.ghc_dev_password, "'", "'\\''"), local.high_service)

  career_bootstrap_path = var.career_bootstrap_sql == "" ? "" : (
    startswith(var.career_bootstrap_sql, "/")
    ? var.career_bootstrap_sql
    : "${path.module}/${var.career_bootstrap_sql}"
  )
}
