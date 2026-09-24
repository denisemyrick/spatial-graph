#!/usr/bin/env bash

set -euo pipefail
export LC_ALL=C

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 WALLET_FILE GHC_DEV_LOGON SQL_COMMAND" >&2
  exit 2
fi

wallet_file=$1
db_logon=$2
sql_command=$3
module_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
stage_dir=$(mktemp -d "${TMPDIR:-/tmp}/ghc-onet.XXXXXX")
trap 'rm -rf "$stage_dir"' EXIT

unzip -q "$module_dir/data/db_30_3_oracle.zip" -d "$stage_dir"
cp "$module_dir/db_scripts/abilities_xlsx_load.sql" "$stage_dir/abilities_xlsx_load.sql"

load_script="$stage_dir/load_all.sql"
{
  printf '%s\n' "SET DEFINE OFF"
  printf '%s\n' "WHENEVER SQLERROR EXIT SQL.SQLCODE"
  for source_file in "$stage_dir"/db_30_3_oracle/[0-9][0-9]_*.sql; do
    printf '@%s\n' "$source_file"
  done
  printf '@%s\n' "$stage_dir/abilities_xlsx_load.sql"
  printf '%s\n' "EXIT"
} > "$load_script"

"$sql_command" \
  -cloudconfig "$wallet_file" \
  "$db_logon" \
  @"$load_script"
