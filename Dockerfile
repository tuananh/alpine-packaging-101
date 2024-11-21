FROM alpine:latest

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk update && apk add abuild build-base

RUN addgroup -g 1000 nonroot \
    && adduser -u 1000 -G nonroot -s /bin/sh -D nonuser

WORKDIR /home/nonroot
USER nonroot
CMD ["/bin/sh"]