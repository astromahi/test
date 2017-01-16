FROM debian:jessie

RUN apt-get update \
    && apt-get install -y ntfs-3g \
    && apt-get clean

COPY usbupdater.sh /usr/bin/
RUN chmod +x /usr/bin/usbupdater.sh

ENTRYPOINT ["usbupdater.sh"]
