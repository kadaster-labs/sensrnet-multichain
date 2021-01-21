FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
  curl \
  dnsutils \
  python \
  python-dev \
  python-pip \
  sqlite3 \
  libsqlite3-dev \
  wget \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Multichain
WORKDIR /tmp
RUN     wget https://www.multichain.com/download/multichain-2.1.1.tar.gz \
        && tar -xvzf multichain-2.1.1.tar.gz \
        && cd multichain-2.1.1 \
        && mv multichaind multichain-cli multichain-util /usr/local/bin \
        && cd /tmp \
        && rm -Rf multichain*

# Multichain Explorer
WORKDIR /root

COPY explorer.tar.gz .
RUN tar -xvzf explorer.tar.gz \
  && rm -Rf explorer.tar.gz

WORKDIR /root/multichain-explorer-master
COPY requirements.txt ./requirements.txt
RUN pip install -r requirements.txt \
  && python setup.py install --user

# Configure container
WORKDIR /root
COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh

EXPOSE 8570
EXPOSE 8571
EXPOSE 2750

ENTRYPOINT ["/root/entrypoint.sh"]
