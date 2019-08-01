FROM debian:stretch

MAINTAINER Me

# Default mopidy configuration
COPY mopidy.conf /var/lib/mopidy/.config/mopidy/mopidy.conf

# Default icecast configuration
COPY icecast.xml /usr/share/icecast/icecast.xml
COPY 500-milliseconds-of-silence.mp3 /usr/share/icecast/web/silence.mp3

# Official Mopidy install for Debian/Ubuntu along with some extensions
# (see https://docs.mopidy.com/en/latest/installation/debian/ )

RUN set -ex \
 && apt-get update \
 && apt-get install -y wget \
 && apt-get install -y gnupg \
 && apt-get install -y curl \
 && wget -q -O - https://apt.mopidy.com/mopidy.gpg | apt-key add - \
 && wget -q -O /etc/apt/sources.list.d/mopidy.list https://apt.mopidy.com/stretch.list \
 && apt-get update \
 && apt-get install -y mopidy \
 && curl -L https://bootstrap.pypa.io/get-pip.py | python - \
 && pip install -U six \
 && pip install \
        Mopidy-Spotmop \
 && apt-get purge --auto-remove -y \
        curl \
        gcc \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* ~/.cache \
 && chown mopidy:audio -R /var/lib/mopidy/.config

# Run as mopidy user
USER mopidy

VOLUME /var/lib/mopidy/local
VOLUME /var/lib/mopidy/media

EXPOSE 6600
EXPOSE 6680

CMD ["/usr/bin/mopidy"]
