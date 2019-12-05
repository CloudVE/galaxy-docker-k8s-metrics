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
scrape data and dump the result into the given influxdb.

You can use a cron job to schedule metrics scraping at a cadence of your choice.

### Ansible for cron job

```yaml
- name: Create a cron job for gathering stats
  cron:
    name: Gather Galaxy Stats
    job: docker run cloudve/galaxy-metrics-scraper:latest <your_env>
    minute: 0
    hour: 0
    user: "<some_low_privilege_user>"
```
