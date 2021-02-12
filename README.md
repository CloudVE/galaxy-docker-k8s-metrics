# galaxy-docker-k8s-metrics
Gathers Galaxy instance statistics for ingestion into an influxdb.

### Usage

```
docker run -e PGHOST="<galaxy_db_host>" -e PGDATABASE="galaxy" -e PGPASSWORD="<galaxy_db_pass>"
           -e INFLUX_URL="http://<influx_host>:8086" -e INFLUX_DB="<database>" -e INFLUX_USER="<user>" -e INFLUX_PASS="<pass>"
           cloudve/galaxy-metrics-scraper:latest

```

If the specified influx database does not exist, it will be automatically created.

### How it works

The container runs the gather-metrics script which uses gxadmin provided functionality to
scrape data and dump the result into the given influxdb. The data from influxdb can be
graphed using the existing Grafana dashboards for Galaxy.

Internally, the docker container runs a crontab which will run at minute, hourly, and daily
schedules to gather various metrics.
