# Career data loaders

`load_bundled_data.sh` extracts `data/db_30_3_oracle.zip`, runs its numbered Oracle SQL scripts as `GHC_DEV`, and then loads `data/Abilities.xlsx` through the generated `abilities_xlsx_load.sql` script into `GHC_ABILITIES_XLSX`.

The generated workbook loader preserves all 15 workbook columns and converts the `MM/YYYY` source date to the first day of that month. The source workbook and archive remain in the Terraform bundle.

## Optional career bootstrap

Place an instructor-approved consolidated SQL script here if the career tables, property graph, embeddings, and `CAREER_PROFILE_*` package sources are available. Set `career_bootstrap_sql = "db_scripts/career_bootstrap.sql"` in the Terraform variables.

The script runs as `GHC_DEV` after the bundled data, database user, and `DBMS_CLOUD_AI` profile are configured. Keep source data and any provider credentials out of the Terraform repository and state unless they are approved for distribution.

Estimated Time: 5 minutes

## Acknowledgements

* **Workshop source** - The career schema and support-script source must be supplied and approved by the workshop instructor.
