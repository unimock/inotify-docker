FROM alpine

RUN apk add --no-cache inotify-tools bash perl cups-client openssl ca-certificates perl-net-ssleay  && \
    apk add swaks --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/ && \
    rm -rf /var/cache/apk/*

ARG TARGETPLATFORM
RUN echo "$TARGETPLATFORM"

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then ARCHITECTURE="amd64"; elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then ARCHITECTURE="arm64"; else ARCHITECTURE="amd64"; fi && \
    wget -O /usr/local/bin/mc https://dl.minio.io/client/mc/release/linux-${ARCHITECTURE}/mc && \
    chmod a+x /usr/local/bin/mc

ADD init.sh /init.sh
RUN chmod 750 /init.sh

CMD ["/init.sh"]

