FROM armbuild/alpine:3.3

ENV MONGO_VERSION 3.2.3

RUN addgroup mongodb && adduser -D -H -G mongodb mongodb

RUN set -ex && apk add --no-cache bash git curl tar scons g++ linux-headers openssl-dev perl python-dev make && \
    cd /tmp/ && git clone https://github.com/mongodb/mongo.git && \
    cd mongo && git checkout r${MONGO_VERSION} && \
    curl -o alpine.patch https://patch-diff.githubusercontent.com/raw/mongodb/mongo/pull/1061.diff && \
    patch -p1 <alpine.patch && \
    curl -o gperftool.patch https://gist.githubusercontent.com/ncopa/520055e642043684da2d/raw/cea0e7a920c1f83271d3543ec78bc1bd0512d8fd/gistfile1.txt && \
    patch -p1 <gperftool.patch && \
    cd src/third_party/mozjs-38 && bash get_sources.sh && \
    export SHELL=/bin/bash && bash gen-config.sh arm linux && cd - && \
    scons mongod -j$(getconf _NPROCESSORS_ONLN) --ssl --disable-warnings-as-errors && \
    scons mongo -j$(getconf _NPROCESSORS_ONLN) --ssl --disable-warnings-as-errors && \
    scons mongos-j$(getconf _NPROCESSORS_ONLN) --ssl --disable-warnings-as-errors && \
    scons install --prefix /usr && \
    cd / && apk del bash git curl tar scons g++ linux-headers openssl-dev perl make && \
    rm -rf /etc/ssl /tmp/* \
      /usr/share/man /var/cache/apk/*

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

VOLUME /data

EXPOSE 27017
CMD ["mongod"]
