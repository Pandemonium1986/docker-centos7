FROM centos:7

LABEL maintainer="Michael Maffait"
LABEL org.opencontainers.image.source="https://github.com/Pandemonium1986/docker-centos7"

# Configure environment variables
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV PYTHONIOENCODING=utf8

# Systemd configuration
STOPSIGNAL SIGRTMIN+3
ENV container=docker

# Install dependencies
RUN yum -y install epel-release && \
  yum -y install \
  openssh-server \
  wget \
  python-pip && \
  yum clean all

# Patch systemd for cgroupv2
RUN wget --quiet --no-check-certificate https://copr.fedorainfracloud.org/coprs/jsynacek/systemd-backports-for-centos-7/repo/epel-7/jsynacek-systemd-backports-for-centos-7-epel-7.repo -O /etc/yum.repos.d/jsynacek-systemd-centos-7.repo && \
  yum update -y && \
  yum clean all

# Remove systemd target
WORKDIR /lib/systemd/system/sysinit.target.wants/
RUN (for i in *; do [ "$i" = systemd-tmpfiles-setup.service ] || rm -f "$i"; done); \
  rm -f /lib/systemd/system/multi-user.target.wants/*;\
  rm -f /etc/systemd/system/*.wants/*;\
  rm -f /lib/systemd/system/local-fs.target.wants/*; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
  rm -f /lib/systemd/system/basic.target.wants/*;\
  rm -f /lib/systemd/system/anaconda.target.wants/*;

WORKDIR /

VOLUME [ "/tmp", "/run" ]

CMD ["/lib/systemd/systemd"]
