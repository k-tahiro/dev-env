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

# sshd installation
RUN yum install -y openssh-server && \
    sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config && \
    systemctl start sshd.service

# xrdp installation
RUN sudo yum install -y git && \
    TMP_DIR="$(mktemp -d)" && \
    sudo -u "${DEVELOPER}" git clone https://github.com/metalefty/X11RDP-RH-Matic.git "${TMP_DIR}" && \
    sudo -u "${DEVELOPER}" cd "${TMP_DIR}" && \
    sudo -u "${DEVELOPER}" ./X11RDP-RH-Matic.sh --with-xorg-driver --nox11rdp

# develop environment creation
USER "${DEVELOPER}"

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
