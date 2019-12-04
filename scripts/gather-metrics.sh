#!/bin/bash

# exit on error
set -e

data=$(mktemp --suffix .gxadmin)

# Export metrics to file
gxadmin meta slurp-current --date > "$data"

# Ship to influxdb
gxadmin meta influx-post "$INFLUX_DATABASE" "$data"

# Cleanup
rm "$data"
