# Provision the Career Graph Database

## Introduction

Use this Terraform stack to provision the database foundation for the career-graph workshop. The stack creates the Autonomous AI Database, configures `GHC_DEV`, and creates the OCI-backed `DBMS_CLOUD_AI` profile.

Estimated Time: 15 minutes

### Objectives

- Provision an Autonomous AI Database 26ai instance.
- Create the graph-enabled `GHC_DEV` database user.
- Configure the workshop GenAI profile and retrieve the APEX URL.
- Load the bundled O*NET 30.3 SQL archive and `Abilities.xlsx` extract.

## Task 1: Review and apply the stack

1. Copy `terraform.tfvars.example` to `terraform.tfvars` and enter the target tenancy, user, compartment, region, and unique suffix.
2. Run `terraform init`, `terraform plan`, and `terraform apply` from this directory. The data load can take several minutes after the database is available.
3. Save the sensitive `adb_admin_password` and `ghc_dev_password` outputs in an approved secret manager.

## Task 2: Finish the workshop setup

1. Import `apex/f100.sql` into the instructor's APEX workspace and map application 100 to `GHC_DEV`.
2. Provide the career graph/embeddings/package script through the optional `career_bootstrap_sql` variable when that approved source is available.
3. Run the workshop verification script and confirm the active graph, O*NET tables, and AI profile are available before the event.

## Acknowledgements

* **Reference configurations** - User-supplied `adb23ai-PropertyGraphs` and `livestack_finance` Terraform stacks.
* **Oracle product documentation** - Autonomous AI Database, ORDS, Graph, and Select AI references.
