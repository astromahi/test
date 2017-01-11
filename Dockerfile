FROM debian:jessie

COPY usbupdater.sh /root/usbupdater.sh

RUN chmod +x /root/usbupdter.sh

ENTRYPOINT ["usbupdter.sh"]
