#!/bin/bash

echo "Gathering one-time galaxy stats..."

# create the db
curl -i -XPOST "$INFLUX_URL/query" --data-urlencode "q=CREATE DATABASE $INFLUX_DB"

data=$(mktemp --suffix .gxadmin)

# send output of all commands to file
{
  # Export all server statistics once on startup
  gxadmin meta slurp-current --date
} > "$data"

# Ship to influxdb
gxadmin meta influx-post "$INFLUX_DB" "$data"

# Cleanup
rm "$data"
