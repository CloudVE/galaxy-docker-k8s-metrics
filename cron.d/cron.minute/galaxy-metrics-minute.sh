#!/bin/bash

data=$(mktemp --suffix .gxadmin)

# send output of all commands to file
{
  gxadmin iquery queue-overview --short-tool-id
  gxadmin iquery queue-detail --all --seconds
  gxadmin iquery jobs-queued
} > "$data"

# Ship to influxdb
gxadmin meta influx-post "$INFLUX_DB" "$data"

# Cleanup
rm "$data"
