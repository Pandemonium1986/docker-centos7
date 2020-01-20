FROM debian:stretch
LABEL maintainer="Michael Maffait"

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    openssh-server \
    python-dev \
    python-pip \
    python-setuptools \
    python-wheel \
    systemd && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean


VOLUME ["/sys/fs/cgroup"]

CMD ["/lib/systemd/systemd"]
