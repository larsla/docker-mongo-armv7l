FROM armbuild/alpine:3.3

ENV MONGO_VERSION 3.2.3

RUN addgroup mongodb && adduser -D -H -G mongodb mongodb

RUN set -ex && apk add --no-cache python gcc g++ git scons curl && \
    cd /tmp/ && git clone https://github.com/mongodb/mongo.git && \
    cd mongo && git checkout r${MONGO_VERSION} && \
    curl -o alpine.patch https://gist.githubusercontent.com/ncopa/520055e642043684da2d/raw/cea0e7a920c1f83271d3543ec78bc1bd0512d8fd/gistfile1.txt && \
    patch -p0 <alpine.patch && \
    scons all -j 4 --disable-warnings-as-errors && \
    scons install --prefix /usr && \
    cd / && apk del python gcc g++ git scons curl && \
    rm -rf /etc/ssl /tmp/* \
      /usr/share/man /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

VOLUME /data

EXPOSE 27017
CMD ["mongod"]
