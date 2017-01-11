FROM debian:jessie

COPY usbupdater.sh /usr/bin/

RUN chmod +x /usr/bin/usbupdater.sh

ENTRYPOINT ["usbupdater.sh"]
