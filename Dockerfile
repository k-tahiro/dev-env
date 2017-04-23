FROM centos:latest
MAINTAINER k-tahiro

# developer user creation
RUN yum install -y sudo && \
    useradd developer && \
    echo "developer:developer" | chpasswd && \
    echo 'developer ALL=(ALL) NOPASSWD: ALL' >>/etc/sudoers
USER developer
WORKDIR /home/developer

# init
RUN sudo yum install -y deltarpm && \
    sudo yum update -y

# anyenv installation
RUN sudo yum install -y git && \
    git clone https://github.com/riywo/anyenv ~/.anyenv && \
    echo 'export PATH="${HOME}/.anyenv/bin:${PATH}"' >>~/.bash_profile && \
    echo 'eval "$(anyenv init -)"' >>~/.bash_profile
ENV PATH "${HOME}/.anyenv/bin:${PATH}"

# Python installation
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

# Node.js installation
ARG NODEJS_VERSION
RUN anyenv install ndenv && \
    eval "$(anyenv init -)" && \
    ndenv install "${NODEJS_VERSION}" && \
    ndenv global "${NODEJS_VERSION}"

# xrdp installation
RUN TMP_DIR="$(mktemp -d)" && \
    git clone https://github.com/metalefty/X11RDP-RH-Matic.git "${TMP_DIR}" && \
    cd "${TMP_DIR}" && \
    ./X11RDP-RH-Matic.sh --with-xorg-driver --nox11rdp

CMD /bin/bash
