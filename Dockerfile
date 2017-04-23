FROM centos:latest
MAINTAINER k-tahiro

# init
ENV container="docker"
VOLUME ["/sys/fs/cgroup"]
RUN yum install -y deltarpm && \
    yum update -y

# developer user creation
ARG DEVELOPER
RUN yum install -y sudo && \
    useradd "${DEVELOPER}" && \
    echo "${DEVELOPER}:${DEVELOPER}" | chpasswd && \
    echo "${DEVELOPER} ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

# develop environment creation
USER "${DEVELOPER}"

## xrdp installation
RUN sudo yum install -y git && \
    TMP_DIR="$(mktemp -d)" && \
    git clone https://github.com/metalefty/X11RDP-RH-Matic.git "${TMP_DIR}" && \
    "${TMP_DIR}/X11RDP-RH-Matic.sh" --with-xorg-driver --nox11rdp

## anyenv installation
ENV PATH="/home/${DEVELOPER}/.anyenv/bin:${PATH}"
RUN git clone https://github.com/riywo/anyenv ~/.anyenv && \
    eval "$(anyenv init -)" && \
    echo 'export PATH="${HOME}/.anyenv/bin:${PATH}"' >>~/.bash_profile && \
    echo 'eval "$(anyenv init -)"' >>~/.bash_profile

## Python installation
ARG PYTHON_VERSION
RUN sudo yum install -y gcc \
                        make \
                        zlib-devel \
                        bzip2 \
                        bzip2-devel \
                        readline-devel \
                        sqlite \
                        sqlite-devel \
                        openssl-devel && \
    anyenv install pyenv && \
    eval "$(anyenv init -)" && \
    pyenv install "${PYTHON_VERSION}" && \
    pyenv global "${PYTHON_VERSION}"

## Node.js installation
ARG NODEJS_VERSION
RUN anyenv install ndenv && \
    eval "$(anyenv init -)" && \
    ndenv install "${NODEJS_VERSION}" && \
    ndenv global "${NODEJS_VERSION}"

# post process
USER root
ENTRYPOINT /sbin/init
