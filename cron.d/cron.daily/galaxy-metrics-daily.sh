#!/bin/bash

# exit on error
set -e

# create the db
curl -i -XPOST "$INFLUX_URL/query" --data-urlencode "q=CREATE DATABASE $INFLUX_DB"

data=$(mktemp --suffix .gxadmin)

# send output of all commands to file
{
  gxadmin iquery users-count
  gxadmin iquery collection-usage
  gxadmin iquery ts-repos
  gxadmin iquery tool-likely-broken
  # Export all server statistics
  gxadmin meta slurp-day $(date -d "$i days ago" "+%Y-%m-%d")
} > "$data"

# Ship to influxdb
gxadmin meta influx-post "$INFLUX_DB" "$data"

# Cleanup
rm "$data"
