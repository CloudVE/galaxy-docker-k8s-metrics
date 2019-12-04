#!/bin/bash

# exit on error
set -e

data=$(mktemp --suffix .gxadmin)

# send output of all commands to file
{
  gxadmin iquery queue-overview
  gxadmin iquery queue-detail
  gxadmin iquery jobs-queued
  gxadmin iquery upload-gb-in-past-hour
  gxadmin iquery users-count
  gxadmin iquery collection-usage
  gxadmin iquery ts-repos
  gxadmin iquery user-disk-usage
  gxadmin iquery tool-errors
  gxadmin iquery tool-likely-broken
  # Export all server statistics
  gxadmin meta slurp-current --date
} > "$data"

# Ship to influxdb
gxadmin meta influx-post "$INFLUX_DATABASE" "$data"

# Cleanup
rm "$data"
