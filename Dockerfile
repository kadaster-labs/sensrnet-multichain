FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
  curl \
  wget \
  dnsutils \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Multichain
WORKDIR /tmp
RUN     wget https://www.multichain.com/download/multichain-2.1.1.tar.gz \
        && tar -xvzf multichain-2.1.1.tar.gz \
        && cd multichain-2.1.1 \
        && mv multichaind multichain-cli multichain-util /usr/local/bin \
        && cd /tmp \
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
