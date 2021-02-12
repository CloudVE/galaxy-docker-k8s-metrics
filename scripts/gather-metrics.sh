#!/bin/bash

# exit on error
set -e

# create the db
curl -i -XPOST "$INFLUX_URL/query" --data-urlencode "q=CREATE DATABASE $INFLUX_DB"

data=$(mktemp --suffix .gxadmin)

# send output of all commands to file
{
  gxadmin iquery queue-overview --short-tool-id
  gxadmin iquery queue-detail --all --seconds
  gxadmin iquery jobs-queued
  gxadmin iquery upload-gb-in-past-hour
  gxadmin iquery users-count
  gxadmin iquery collection-usage
  gxadmin iquery ts-repos
  gxadmin iquery user-disk-usage
  gxadmin iquery tool-errors
  gxadmin iquery tool-likely-broken
  # Export all server statistics
  gxadmin meta slurp-current
  gxadmin meta slurp-day $(date -d "$i days ago" "+%Y-%m-%d")
} > "$data"

# Ship to influxdb
gxadmin meta influx-post "$INFLUX_DB" "$data"

# Cleanup
rm "$data"
