# Metrics scraper for Galaxy.
# Uses gxadmin functionality for extracting metrics from the galaxy
# database and sending them to influxdb.
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
ARG APP_USER=gxadmin

# Pass these values to scrape metrics from Galaxy into influx using gxadmin.
# The postgres database must be the galaxy database.
ENV PGHOST ""
ENV PGDATABASE ""
ENV PGPASSWORD ""
ENV INFLUX_URL ""
ENV INFLUX_DB ""
ENV INFLUX_USER ""
ENV INFLUX_PASS ""

# Install python-virtualenv
RUN set -xe; \
    apt-get -qq update && apt-get install -y --no-install-recommends \
        tini \
        cron \
        ca-certificates \
        python3.8 \
        curl \
        postgresql-client \
    && ln -s /usr/bin/python3.8 /usr/bin/python3 \
    && ln -s /usr/bin/python3.8 /usr/bin/python \
    && curl -L https://github.com/usegalaxy-eu/gxadmin/releases/latest/download/gxadmin > /usr/bin/gxadmin \
    && chmod +x /usr/bin/gxadmin \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* \
    && adduser --system --group $APP_USER;

ADD --chown=gxadmin:gxadmin ./cron.d/ /opt/galaxy/cron.d/

# Create Galaxy user, group, directory; chown
RUN set -xe; \
    chmod -R 0644 /opt/galaxy/cron.d/; \
    chmod -R +x /opt/galaxy/cron.d/; \
    touch /var/log/cron.log; \
    chown $APP_USER:$APP_USER /var/log/cron.log; \
    crontab -u $APP_USER /opt/galaxy/cron.d/crontab; \
    # create location for container env vars which will be passed into cron jobs
    mkdir /temp-ram-disk; \
    chown $APP_USER:$APP_USER /temp-ram-disk;

ENTRYPOINT ["/usr/bin/tini", "--"]

# [optional] to run:
CMD /bin/bash -c declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID|_=|IFS' > /temp-ram-disk/container.env && chown gxadmin:gxadmin /temp-ram-disk/container.env && tail -f /var/log/cron.log 2> /dev/null & cron -f
