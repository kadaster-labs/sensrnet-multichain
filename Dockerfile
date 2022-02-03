FROM alpine:3.14.0

RUN     apk update \
        && apk upgrade \
        && apk add bash \
        && apk add bind-tools \
        && apk add busybox \
        && apk add ca-certificates \
        && apk add tar \
        && apk add wget \
        && rm -rf /var/cache/apk/*

# Multichain
WORKDIR /tmp
RUN     MULTICHAIN_VERSION=2.1.2 \
        && wget https://www.multichain.com/download/multichain-$MULTICHAIN_VERSION.tar.gz \
        && tar -xvzf multichain-$MULTICHAIN_VERSION.tar.gz \
        && cd multichain-$MULTICHAIN_VERSION \
        && mv multichaind multichain-cli multichain-util /usr/bin/ \
        && cd ../ \
        && rm -Rf multichain*

# Configure container
WORKDIR /root

COPY multichain.sh ./multichain.sh
RUN chmod +x multichain.sh

COPY streams.sh ./streams.sh
RUN chmod +x streams.sh

COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh

EXPOSE 8570
EXPOSE 8571

ENTRYPOINT [ "/root/entrypoint.sh" ]
CMD [ "start" ]