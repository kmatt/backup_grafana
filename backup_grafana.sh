#!/bin/bash
## Written by: Mischa Gresser
## Last modified: 11/28/18

BACKUP_LOCATION=$PWD

## Uses Backup user API key to get a list of dashboards
## Takes this list and passes it to jq to parse out the values in the uri key
dashboards=$(curl -s -H "Authorization: Bearer $GRAFANA_TOKEN" $GRAFANA_URL/api/search | jq -r 'keys[] as $k | "\(.[$k] | .uri)"')

## For each dashboard uses Backup user API to get the JSON for that URI
## Takes the results and passes it to jq to parse out the dashboard key contents
for db in $dashboards
do
    echo $db
    fn=$(basename $db)
    curl -s -H "Authorization: Bearer $GRAFANA_TOKEN" "$GRAFANA_URL/api/dashboards/$db" | jq .dashboard > "$BACKUP_LOCATION/$fn.json"
done
