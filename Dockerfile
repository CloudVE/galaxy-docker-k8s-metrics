# Metrics scraper for Galaxy.
# Uses gxadmin functionality for extracting metrics from the galaxy
# database and sending them to influxdb.
FROM ubuntu:18.04
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
        vim \
        ca-certificates \
        python2.7 \
        curl \
        postgresql-client \
    && ln -s /usr/bin/python2.7 /usr/bin/python \
    && curl https://raw.githubusercontent.com/cloudve/gxadmin/master/gxadmin > /usr/bin/gxadmin \
    && chmod +x /usr/bin/gxadmin \
    && apt-get autoremove -y && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/*

ADD ./scripts/gather-metrics.sh /usr/bin/gather-metrics.sh

# Create Galaxy user, group, directory; chown
RUN set -xe; \
    adduser --system --group $APP_USER; \
    chmod +x /usr/bin/gather-metrics.sh;

USER $APP_USER

# [optional] to run:
CMD gather-metrics.sh
