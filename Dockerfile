FROM armbuild/alpine:3.3

ENV MONGO_VERSION 3.3.2

RUN addgroup mongodb && adduser -D -H -G mongodb mongodb

RUN apk add --no-cache python gcc g++ git scons && \
    cd /tmp/ && git clone https://github.com/mongodb/mongo.git && \
    cd mongo && git checkout r${MONGO_VERSION} && \
    scons all --disable-warnings-as-errors && \
    scons install --prefix /usr && \
    cd / && apk del python gcc g++ git scons && \
    rm -rf /etc/ssl /tmp/* \
      /usr/share/man /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

VOLUME /data

EXPOSE 27017
CMD ["mongod"]
