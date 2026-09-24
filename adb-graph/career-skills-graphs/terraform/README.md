# Terraform – Find Roles Hidden in Your Skills using Graphs

This stack provisions the Autonomous AI Database foundation for the Grace Hopper Conference career-graph workshop.

It follows the `adb23ai-PropertyGraphs` baseline. It adds the GenAI credential and profile flow from `livestack_finance`.

Estimated Time: 15 minutes

### Objectives

- Provision an Autonomous AI Database 26ai foundation.
- Create and configure the `GHC_DEV` database user.
- Create the OCI-backed `DBMS_CLOUD_AI` profile used by the workshop.
- Load the bundled O*NET 30.3 data and abilities workbook into `GHC_DEV`.

## What it creates

- An Oracle Autonomous AI Database using the 26ai release and OLTP workload.
- The bundled O*NET 30.3 SQL archive, loaded in filename order as `GHC_DEV`.
- The bundled `Abilities.xlsx` extract, loaded as `GHC_ABILITIES_XLSX` in `GHC_DEV`.
- A wallet written to `atp_wallet.zip` with file mode `0600`.
- Database user `GHC_DEV` with `GRAPH_DEVELOPER`, `CONNECT`, `RESOURCE`, `DBMS_CLOUD`, `DBMS_CLOUD_AI`, and `DBMS_CLOUD_AI_AGENT` access.
- ORDS schema enablement for `GHC_DEV`, which provides the Web Access/REST foundation. ORDS GraphQL endpoints are exposed for REST-enabled objects.
- An OCI API key for the Terraform user and a `GHC_CAREER_AI` `DBMS_CLOUD_AI` profile using OCI Generative AI.
- Outputs for APEX, SQL Developer Web, ORDS, GraphQL, Graph Studio, the wallet, and the supplied APEX export.

Terraform state holds the database, user, wallet, and GenAI credential. Protect state with encryption and access controls. Do not commit `terraform.tfstate`, generated SQL, wallets, or private keys.

## Prerequisites

- Terraform 1.5 or later.
- OCI CLI configuration or equivalent OCI provider authentication for the Terraform user.
- Permission to create an Autonomous Database in the target compartment.
- Permission to create an API key for the OCI user.
- SQLcl (`sql`) on the machine running `terraform apply`.
- `unzip` on the machine running `terraform apply`.
- A tenancy entitlement for `BRING_YOUR_OWN_LICENSE`, or set `license_model = "LICENSE_INCLUDED"`.

## Apply

```text
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with the target OCIDs and region.
terraform init
terraform fmt
terraform plan
terraform apply
```

Retrieve sensitive passwords only when needed:

```text
terraform output -raw adb_admin_password
terraform output -raw ghc_dev_password
```

## APEX application import

The supplied [f100.sql](apex/f100.sql) export is included for the instructor. Terraform leaves its import manual. The export needs an APEX workspace and account context. Its source workspace identifier does not transfer between databases.

After apply:

1. Open the `apex_url` output and use the instructor-provided APEX workspace.
2. Import `apex/f100.sql` through App Builder.
3. Keep application 100 and map the parsing schema to `GHC_DEV`.
4. Create or use a separate APEX account for the application. The APEX Accounts login is separate from the database password.

## Career schema/data bootstrap

Terraform automatically loads the bundled O*NET 30.3 SQL archive and the `Abilities.xlsx` extract as `GHC_DEV`. The normalized O*NET archive creates the tables described by its numbered scripts. The workbook is preserved as a denormalized `GHC_ABILITIES_XLSX` table so it does not conflict with the archive's normalized `ABILITIES` table.

The 320 MB O*NET archive is extracted to a temporary directory during apply. Set `load_bundled_career_data = false` only when the data is already present or an instructor intentionally wants to skip the load.

The supplied data does not include the workshop-specific property graph DDL, embeddings loader, or `CAREER_PROFILE_*` package sources. The database validation found these objects in the existing environment. Their definitions were not available to bundle here.

If an instructor-approved consolidated SQL script is available, pass it with:

```text
career_bootstrap_sql = "db_scripts/career_bootstrap.sql"
```

Terraform runs that script as `GHC_DEV` after user and GenAI setup. The script should create the career tables, load data, create embeddings, create the active property graph, and install the support packages expected by the APEX app.

## Access notes

- `GHC_DEV` is the database/parsing schema. The APEX application uses APEX Accounts authentication.
- Web Access and REST are enabled by `ORDS_ADMIN.ENABLE_SCHEMA` in `create_user.sql.tmpl`.
- ORDS GraphQL is available at the `graphql_url` output after the target tables or views are REST-enabled. Schema enablement alone does not expose every table.
- The default `0.0.0.0/0` allow-list suits a controlled workshop only. Replace it with event network CIDRs for production or shared environments.
- Terraform generates the OCI private API key. It writes the key to a `0600` rendered SQL file and stores it in Terraform state. Protect the state and working directory.

## Acknowledgements

* **Oracle documentation** - Autonomous Database, Graph, ORDS, and Select AI documentation.
* **Reference configurations** - User-supplied `adb23ai-PropertyGraphs` and `livestack_finance` Terraform stacks.
