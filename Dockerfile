FROM ioft/armhf-ubuntu:15.10

RUN apt-get update && apt-get install mongodb-server && apt-cache clean

COPY run.sh /run.sh
COPY set_mongodb_password.sh /set_mongodb_password.sh
COPY setup_replset.sh /setup_replset.sh
RUN chmod +x /*.sh


ENTRYPOINT ["/run.sh"]

VOLUME /data

EXPOSE 27017
